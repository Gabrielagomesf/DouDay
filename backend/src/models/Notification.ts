import mongoose, { Document, Schema } from 'mongoose';

export type NotificationType = 'task' | 'finance' | 'agenda' | 'checkin' | 'system';

export interface INotification extends Document {
  coupleId: mongoose.Types.ObjectId;
  type: NotificationType;
  title: string;
  body: string;
  data?: Record<string, any>;
  isRead: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const NotificationSchema = new Schema<INotification>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    type: { type: String, enum: ['task', 'finance', 'agenda', 'checkin', 'system'], default: 'system', index: true },
    title: { type: String, required: true },
    body: { type: String, default: '' },
    data: { type: Schema.Types.Mixed },
    isRead: { type: Boolean, default: false, index: true },
  },
  { timestamps: true }
);

export default mongoose.model<INotification>('Notification', NotificationSchema);

