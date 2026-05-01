import mongoose, { Document, Schema } from 'mongoose';
import bcrypt from 'bcryptjs';

export interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  avatar?: string;
  relationshipStatus: 'single' | 'pending' | 'connected';
  coupleId?: mongoose.Types.ObjectId;
  partnerId?: mongoose.Types.ObjectId;
  partnerName?: string;
  inviteCode?: string;
  fcmToken?: string;
  isPremium: boolean;
  premiumExpiresAt?: Date;
  lastLoginAt?: Date;
  createdAt?: Date;
  updatedAt?: Date;
  passwordResetCodeHash?: string;
  passwordResetCodeExpiresAt?: Date;
  comparePassword(candidatePassword: string): Promise<boolean>;
  generateInviteCode(): string;
  isModified(path: string): boolean;
}

const userSchema = new Schema<IUser>({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    maxlength: [50, 'Name cannot exceed 50 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Please enter a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [6, 'Password must be at least 6 characters long'],
    select: false
  },
  avatar: {
    type: String,
    default: null
  },
  relationshipStatus: {
    type: String,
    enum: ['single', 'pending', 'connected'],
    default: 'single'
  },
  coupleId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Couple',
    default: null
  },
  partnerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  partnerName: {
    type: String,
    default: null
  },
  inviteCode: {
    type: String,
    unique: true,
    sparse: true,
    default: undefined
  },
  fcmToken: {
    type: String,
    default: null
  },
  isPremium: {
    type: Boolean,
    default: false
  },
  premiumExpiresAt: {
    type: Date,
    default: null
  },
  lastLoginAt: {
    type: Date,
    default: null
  },
  passwordResetCodeHash: {
    type: String,
    default: null,
    select: false
  },
  passwordResetCodeExpiresAt: {
    type: Date,
    default: null
  }
}, {
  timestamps: true,
  toJSON: {
    transform: function(doc: any, ret: any) {
      delete ret.password;
      return ret;
    }
  }
});

// Indexes
userSchema.index({ email: 1 });
userSchema.index({ inviteCode: 1 });
userSchema.index({ coupleId: 1 });
userSchema.index({ partnerId: 1 });

// Pre-save middleware to hash password
userSchema.pre('save', async function(this: IUser, next: any) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(12);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error as Error);
  }
});

// Instance methods
userSchema.methods.comparePassword = async function(this: IUser, candidatePassword: string): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.generateInviteCode = function(this: IUser): string {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let code = 'DUO-';
  for (let i = 0; i < 4; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
};

// Static methods
interface UserModel extends mongoose.Model<IUser> {
  findByEmail(email: string): Promise<IUser | null>;
  findByInviteCode(inviteCode: string): Promise<IUser | null>;
}

userSchema.statics.findByEmail = function(email: string) {
  return this.findOne({ email }).select('+password');
};

userSchema.statics.findByInviteCode = function(inviteCode: string) {
  return this.findOne({ inviteCode, relationshipStatus: 'pending' });
};

const User = mongoose.model<IUser, UserModel>('User', userSchema);

export default User;
