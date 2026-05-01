import mongoose, { Document, Schema } from 'mongoose';

export type Mood = 'very_good' | 'good' | 'neutral' | 'tired' | 'stressed';

export interface ICheckin extends Document {
  coupleId: mongoose.Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  mood: Mood;
  comment?: string;
  dayKey: string; // YYYY-MM-DD (UTC)
  createdAt: Date;
  updatedAt: Date;
}

const CheckinSchema = new Schema<ICheckin>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    mood: { type: String, enum: ['very_good', 'good', 'neutral', 'tired', 'stressed'], required: true, index: true },
    comment: { type: String, default: '' },
    dayKey: { type: String, required: true, index: true },
  },
  { timestamps: true }
);

CheckinSchema.index({ coupleId: 1, userId: 1, dayKey: 1 }, { unique: true });

export default mongoose.model<ICheckin>('Checkin', CheckinSchema);

