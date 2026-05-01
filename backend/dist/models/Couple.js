"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importStar(require("mongoose"));
const coupleSchema = new mongoose_1.Schema({
    user1Id: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    user2Id: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'User',
        default: null
    },
    user1Name: {
        type: String,
        required: true,
        trim: true
    },
    user2Name: {
        type: String,
        default: null
    },
    status: {
        type: String,
        enum: ['pending', 'connected', 'disconnected'],
        default: 'pending'
    },
    connectedAt: {
        type: Date,
        default: null
    },
    inviteCode: {
        type: String,
        required: true,
        unique: true
    },
    anniversary: {
        type: Date,
        default: null
    },
    relationshipGoal: {
        type: String,
        maxlength: [200, 'Relationship goal cannot exceed 200 characters'],
        default: null
    },
    sharedNotes: [{
            content: {
                type: String,
                required: true,
                maxlength: [500, 'Note cannot exceed 500 characters']
            },
            authorId: {
                type: mongoose_1.default.Schema.Types.ObjectId,
                ref: 'User',
                required: true
            },
            isPinned: {
                type: Boolean,
                default: false
            },
            createdAt: {
                type: Date,
                default: Date.now
            }
        }]
}, {
    timestamps: true
});
// Indexes
coupleSchema.index({ user1Id: 1 });
coupleSchema.index({ user2Id: 1 });
coupleSchema.index({ inviteCode: 1 });
coupleSchema.index({ status: 1 });
// Pre-save middleware to set connectedAt when status changes to connected
coupleSchema.pre('save', function (next) {
    if (this.isModified('status') && this.status === 'connected' && !this.connectedAt) {
        this.connectedAt = new Date();
    }
    next();
});
// Static methods
coupleSchema.statics.findByUserId = function (userId) {
    return this.findOne({
        $or: [
            { user1Id: userId },
            { user2Id: userId }
        ]
    }).populate('user1Id user2Id', 'name email avatar');
};
coupleSchema.statics.findByInviteCode = function (inviteCode) {
    return this.findOne({ inviteCode, status: 'pending' })
        .populate('user1Id', 'name email avatar');
};
coupleSchema.statics.findConnectedCouple = function (userId) {
    return this.findOne({
        $and: [
            {
                $or: [
                    { user1Id: userId },
                    { user2Id: userId }
                ]
            },
            { status: 'connected' }
        ]
    }).populate('user1Id user2Id', 'name email avatar');
};
// Instance methods
coupleSchema.methods.addSharedNote = function (content, authorId) {
    if (!this.sharedNotes) {
        this.sharedNotes = [];
    }
    this.sharedNotes.push({
        content,
        authorId,
        isPinned: false,
        createdAt: new Date()
    });
    return this.save();
};
coupleSchema.methods.updateRelationshipGoal = function (goal) {
    this.relationshipGoal = goal;
    return this.save();
};
coupleSchema.methods.setAnniversary = function (date) {
    this.anniversary = date;
    return this.save();
};
const Couple = mongoose_1.default.model('Couple', coupleSchema);
exports.default = Couple;
