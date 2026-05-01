import mongoose, { Document, Schema } from 'mongoose';

export type TaskPriority = 'low' | 'medium' | 'high';
export type TaskCategory = 'home' | 'market' | 'work' | 'personal' | 'other';
export type TaskRepeat = 'none' | 'daily' | 'weekly' | 'monthly';
export type TaskReminder = '10m' | '1h' | '1d' | 'none';
export type TaskStatus = 'pending' | 'completed';
export type TaskAssignee = 'me' | 'partner' | 'both';

export interface ITask extends Document {
  coupleId: mongoose.Types.ObjectId;
  title: string;
  description?: string;
  assignee: TaskAssignee;
  dueAt?: Date;
  priority: TaskPriority;
  category: TaskCategory;
  repeat: TaskRepeat;
  reminder: TaskReminder;
  status: TaskStatus;
  createdBy: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
  completedAt?: Date;
}

const TaskSchema = new Schema<ITask>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    title: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    assignee: { type: String, enum: ['me', 'partner', 'both'], default: 'both' },
    dueAt: { type: Date },
    priority: { type: String, enum: ['low', 'medium', 'high'], default: 'medium', index: true },
    category: { type: String, enum: ['home', 'market', 'work', 'personal', 'other'], default: 'home', index: true },
    repeat: { type: String, enum: ['none', 'daily', 'weekly', 'monthly'], default: 'none' },
    reminder: { type: String, enum: ['10m', '1h', '1d', 'none'], default: 'none' },
    status: { type: String, enum: ['pending', 'completed'], default: 'pending', index: true },
    completedAt: { type: Date },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

export default mongoose.model<ITask>('Task', TaskSchema);

