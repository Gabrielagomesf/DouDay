"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const FinanceBill_1 = __importDefault(require("../models/FinanceBill"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
// Summary
router.get('/summary', async (req, res, next) => {
    try {
        const user = req.user;
        const monthStr = req.query.month ?? undefined; // YYYY-MM
        const now = new Date();
        const month = monthStr
            ? new Date(`${monthStr}-01T00:00:00.000Z`)
            : new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));
        const nextMonth = new Date(Date.UTC(month.getUTCFullYear(), month.getUTCMonth() + 1, 1));
        const bills = await FinanceBill_1.default.find({
            coupleId: user.coupleId,
            dueAt: { $gte: month, $lt: nextMonth },
        });
        const total = bills.reduce((s, b) => s + (b.amount || 0), 0);
        const pending = bills.filter((b) => b.status === 'pending').length;
        const paid = bills.filter((b) => b.status === 'paid').length;
        res.json({
            summary: {
                month: month.toISOString().substring(0, 7),
                total,
                pending,
                paid,
            },
        });
    }
    catch (e) {
        next(e);
    }
});
// List bills
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { status, category } = req.query;
        const query = { coupleId: user.coupleId };
        if (status)
            query.status = status;
        if (category)
            query.category = category;
        const bills = await FinanceBill_1.default.find(query).sort({ dueAt: 1 }).limit(500);
        res.json({ bills });
    }
    catch (e) {
        next(e);
    }
});
// Create bill
router.post('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { name, amount, category, dueAt, responsible, splitType, splitMe, splitPartner, status, receiptUrl, notes, } = req.body || {};
        if (!name || typeof name !== 'string')
            return res.status(400).json({ error: 'Name is required' });
        if (amount === undefined || Number.isNaN(Number(amount)))
            return res.status(400).json({ error: 'Amount is required' });
        if (!dueAt)
            return res.status(400).json({ error: 'dueAt is required' });
        const bill = await FinanceBill_1.default.create({
            coupleId: user.coupleId,
            name,
            amount: Number(amount),
            category,
            dueAt: new Date(dueAt),
            responsible,
            splitType,
            splitMe,
            splitPartner,
            status,
            receiptUrl,
            notes,
            createdBy: user._id,
        });
        res.status(201).json({ bill });
    }
    catch (e) {
        next(e);
    }
});
// Get bill
router.get('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const bill = await FinanceBill_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!bill)
            return res.status(404).json({ error: 'Bill not found' });
        res.json({ bill });
    }
    catch (e) {
        next(e);
    }
});
// Update bill
router.put('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const updates = { ...req.body };
        if (updates.dueAt)
            updates.dueAt = new Date(updates.dueAt);
        const bill = await FinanceBill_1.default.findOneAndUpdate({ _id: req.params.id, coupleId: user.coupleId }, { $set: updates }, { new: true });
        if (!bill)
            return res.status(404).json({ error: 'Bill not found' });
        res.json({ bill });
    }
    catch (e) {
        next(e);
    }
});
// Mark paid/unpaid
router.patch('/:id/status', async (req, res, next) => {
    try {
        const user = req.user;
        const { status } = req.body || {};
        if (status !== 'pending' && status !== 'paid')
            return res.status(400).json({ error: 'Invalid status' });
        const bill = await FinanceBill_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!bill)
            return res.status(404).json({ error: 'Bill not found' });
        bill.status = status;
        bill.paidAt = status === 'paid' ? new Date() : undefined;
        bill.paidBy = status === 'paid' ? user._id : undefined;
        await bill.save();
        res.json({ bill });
    }
    catch (e) {
        next(e);
    }
});
// Delete bill
router.delete('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const result = await FinanceBill_1.default.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
        if (result.deletedCount === 0)
            return res.status(404).json({ error: 'Bill not found' });
        res.json({ message: 'Deleted' });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
