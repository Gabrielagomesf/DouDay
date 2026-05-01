import mongoose, { Document, Schema } from 'mongoose';

export type MissionScope = 'daily' | 'weekly';
export type MissionStatus = 'pending' | 'completed';

export interface IMission extends Document {
  coupleId: mongoose.Types.ObjectId;
  scope: MissionScope;
  title: string;
  points: number;
  dayKey?: string; // for daily missions
  weekKey?: string; // YYYY-WW
  status: MissionStatus;
  completedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const MissionSchema = new Schema<IMission>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    scope: { type: String, enum: ['daily', 'weekly'], required: true, index: true },
    title: { type: String, required: true, trim: true },
    points: { type: Number, default: 10 },
    dayKey: { type: String, index: true },
    weekKey: { type: String, index: true },
    status: { type: String, enum: ['pending', 'completed'], default: 'pending', index: true },
    completedAt: { type: Date },
  },
  { timestamps: true }
);

MissionSchema.index({ coupleId: 1, scope: 1, dayKey: 1, title: 1 }, { unique: false });

export default mongoose.model<IMission>('Mission', MissionSchema);

