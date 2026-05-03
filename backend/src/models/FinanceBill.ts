import mongoose, { Document, Schema } from 'mongoose';

export type FinanceCategory =
  | 'rent'
  | 'internet'
  | 'market'
  | 'leisure'
  | 'transport'
  | 'subscriptions'
  | 'subscription'
  | 'other';

export type SplitType = 'half' | 'fixed' | 'percent';
export type BillStatus = 'pending' | 'paid';
export type BillResponsible = 'me' | 'partner' | 'both';

export interface IFinanceBill extends Document {
  coupleId: mongoose.Types.ObjectId;
  name: string;
  amount: number;
  category: FinanceCategory;
  dueAt: Date;
  responsible: BillResponsible;
  splitType: SplitType;
  splitMe?: number;
  splitPartner?: number;
  status: BillStatus;
  receiptUrl?: string;
  notes?: string;
  paidAt?: Date;
  paidBy?: mongoose.Types.ObjectId;
  createdBy: mongoose.Types.ObjectId;
  createdAt: Date;
  updatedAt: Date;
}

const FinanceBillSchema = new Schema<IFinanceBill>(
  {
    coupleId: { type: Schema.Types.ObjectId, ref: 'Couple', required: true, index: true },
    name: { type: String, required: true, trim: true },
    amount: { type: Number, required: true, min: 0 },
    category: {
      type: String,
      enum: ['rent', 'internet', 'market', 'leisure', 'transport', 'subscriptions', 'subscription', 'other'],
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
    paidBy: { type: Schema.Types.ObjectId, ref: 'User' },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  },
  { timestamps: true }
);

export default mongoose.model<IFinanceBill>('FinanceBill', FinanceBillSchema);

