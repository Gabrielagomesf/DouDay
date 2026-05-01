import mongoose, { Document, Schema } from 'mongoose';

export type NoteCategory = 'general' | 'home' | 'work' | 'personal' | 'other';

export interface INote extends Document {
  coupleId: mongoose.Types.ObjectId;
  title: string;
  content: string;
  category: NoteCategory;
  isPinned: boolean;
  createdBy: mongoose.Types.ObjectId;
  updatedAt: Date;
  createdAt: Date;
}

const NoteSchema = new Schema<INote>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    title: { type: String, required: true, trim: true },
    content: { type: String, default: '' },
    category: { type: String, enum: ['general', 'home', 'work', 'personal', 'other'], default: 'general', index: true },
    isPinned: { type: Boolean, default: false, index: true },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

export default mongoose.model<INote>('Note', NoteSchema);

