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
const FinanceBillSchema = new mongoose_1.Schema({
    coupleId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    name: { type: String, required: true, trim: true },
    amount: { type: Number, required: true, min: 0 },
    category: {
        type: String,
        enum: ['rent', 'internet', 'market', 'leisure', 'transport', 'subscriptions', 'other'],
        default: 'other',
        index: true,
    },
    dueAt: { type: Date, required: true, index: true },
    responsible: { type: String, enum: ['me', 'partner', 'both'], default: 'both', index: true },
    splitType: { type: String, enum: ['half', 'fixed', 'percent'], default: 'half' },
    splitMe: { type: Number },
    splitPartner: { type: Number },
    status: { type: String, enum: ['pending', 'paid'], default: 'pending', index: true },
    receiptUrl: { type: String, default: '' },
    notes: { type: String, default: '' },
    paidAt: { type: Date },
    paidBy: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User' },
    createdBy: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User', required: true },
}, { timestamps: true });
exports.default = mongoose_1.default.model('FinanceBill', FinanceBillSchema);
