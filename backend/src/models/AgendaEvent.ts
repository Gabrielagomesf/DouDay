import mongoose, { Document, Schema } from 'mongoose';

export type AgendaParticipants = 'me' | 'partner' | 'both';
export type AgendaRepeat = 'none' | 'daily' | 'weekly' | 'monthly';
export type AgendaReminder = '10m' | '1h' | '1d' | 'none';

export interface IAgendaEvent extends Document {
  coupleId: mongoose.Types.ObjectId;
  title: string;
  description?: string;
  location?: string;
  participants: AgendaParticipants;
  startAt: Date;
  endAt: Date;
  repeat: AgendaRepeat;
  reminder: AgendaReminder;
  createdBy: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const AgendaEventSchema = new Schema<IAgendaEvent>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    title: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    location: { type: String, default: '' },
    participants: { type: String, enum: ['me', 'partner', 'both'], default: 'both', index: true },
    startAt: { type: Date, required: true, index: true },
    endAt: { type: Date, required: true, index: true },
    repeat: { type: String, enum: ['none', 'daily', 'weekly', 'monthly'], default: 'none' },
    reminder: { type: String, enum: ['10m', '1h', '1d', 'none'], default: 'none' },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

export default mongoose.model<IAgendaEvent>('AgendaEvent', AgendaEventSchema);

