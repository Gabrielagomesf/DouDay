import mongoose, { Document, Schema } from 'mongoose';

interface INote {
  content: string;
  authorId: mongoose.Types.ObjectId;
  isPinned: boolean;
  createdAt: Date;
}

export interface ICouple extends Document {
  user1Id: mongoose.Types.ObjectId;
  user2Id: mongoose.Types.ObjectId;
  user1Name: string;
  user2Name: string;
  status: 'pending' | 'connected' | 'disconnected';
  connectedAt?: Date;
  inviteCode: string;
  anniversary?: Date;
  relationshipGoal?: string;
  sharedNotes?: INote[];
  createdAt: Date;
  updatedAt: Date;
  isModified(path: string): boolean;
  addSharedNote(content: string, authorId: mongoose.Types.ObjectId): Promise<ICouple>;
  updateRelationshipGoal(goal: string): Promise<ICouple>;
  setAnniversary(date: Date): Promise<ICouple>;
}

const coupleSchema = new Schema<ICouple>({
  user1Id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  user2Id: {
    type: mongoose.Schema.Types.ObjectId,
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
      type: mongoose.Schema.Types.ObjectId,
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
coupleSchema.index({ status: 1 });

// Pre-save middleware to set connectedAt when status changes to connected
coupleSchema.pre('save', function(this: ICouple, next: any) {
  if (this.isModified('status') && this.status === 'connected' && !this.connectedAt) {
    this.connectedAt = new Date();
  }
  next();
});

// Static methods
coupleSchema.statics.findByUserId = function(userId: mongoose.Types.ObjectId) {
  return this.findOne({
    $or: [
      { user1Id: userId },
      { user2Id: userId }
    ]
  }).populate('user1Id user2Id', 'name email avatar');
};

coupleSchema.statics.findByInviteCode = function(inviteCode: string) {
  return this.findOne({ inviteCode, status: 'pending' })
    .populate('user1Id', 'name email avatar');
};

coupleSchema.statics.findConnectedCouple = function(userId: mongoose.Types.ObjectId) {
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
coupleSchema.methods.addSharedNote = function(this: ICouple, content: string, authorId: mongoose.Types.ObjectId) {
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

coupleSchema.methods.updateRelationshipGoal = function(this: ICouple, goal: string) {
  this.relationshipGoal = goal;
  return this.save();
};

coupleSchema.methods.setAnniversary = function(this: ICouple, date: Date) {
  this.anniversary = date;
  return this.save();
};

const Couple = mongoose.model<ICouple>('Couple', coupleSchema);

export default Couple;
