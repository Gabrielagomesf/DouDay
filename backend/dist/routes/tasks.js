"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const Task_1 = __importDefault(require("../models/Task"));
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
function normalizeDateOnly(dateStr) {
    if (!dateStr)
        return undefined;
    const d = new Date(dateStr);
    if (Number.isNaN(d.getTime()))
        return undefined;
    d.setHours(0, 0, 0, 0);
    return d;
}
// List tasks with filters
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { filter, status, assignee, category, priority, q } = req.query;
        const query = { coupleId: user.coupleId };
        if (status)
            query.status = status;
        if (assignee)
            query.assignee = assignee;
        if (category)
            query.category = category;
        if (priority)
            query.priority = priority;
        if (q)
            query.title = { $regex: String(q), $options: 'i' };
        const today = normalizeDateOnly(new Date().toISOString());
        if (filter === 'today' && today) {
            const end = new Date(today);
            end.setDate(end.getDate() + 1);
            query.dueAt = { $gte: today, $lt: end };
        }
        if (filter === 'overdue' && today) {
            query.dueAt = { $lt: today };
            query.status = 'pending';
        }
        if (filter === 'completed') {
            query.status = 'completed';
        }
        const tasks = await Task_1.default.find(query).sort({ dueAt: 1, createdAt: -1 }).limit(500);
        res.json({ tasks });
    }
    catch (e) {
        next(e);
    }
});
// Create task
router.post('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { title, description, assignee, dueAt, priority, category, repeat, reminder, } = req.body || {};
        if (!title || typeof title !== 'string') {
            return res.status(400).json({ error: 'Title is required' });
        }
        const task = await Task_1.default.create({
            coupleId: user.coupleId,
            title,
            description,
            assignee,
            dueAt: dueAt ? new Date(dueAt) : undefined,
            priority,
            category,
            repeat,
            reminder,
            createdBy: user._id,
            status: 'pending',
        });
        res.status(201).json({ task });
    }
    catch (e) {
        next(e);
    }
});
// Get task
router.get('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const task = await Task_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!task)
            return res.status(404).json({ error: 'Task not found' });
        res.json({ task });
    }
    catch (e) {
        next(e);
    }
});
// Update task
router.put('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const updates = { ...req.body };
        if (updates.dueAt)
            updates.dueAt = new Date(updates.dueAt);
        const task = await Task_1.default.findOneAndUpdate({ _id: req.params.id, coupleId: user.coupleId }, { $set: updates }, { new: true });
        if (!task)
            return res.status(404).json({ error: 'Task not found' });
        res.json({ task });
    }
    catch (e) {
        next(e);
    }
});
// Mark completed / uncompleted
router.patch('/:id/status', async (req, res, next) => {
    try {
        const user = req.user;
        const { status } = req.body || {};
        if (status !== 'pending' && status !== 'completed') {
            return res.status(400).json({ error: 'Invalid status' });
        }
        const task = await Task_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!task)
            return res.status(404).json({ error: 'Task not found' });
        task.status = status;
        task.completedAt = status === 'completed' ? new Date() : undefined;
        await task.save();
        res.json({ task });
    }
    catch (e) {
        next(e);
    }
});
// Delete task
router.delete('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const result = await Task_1.default.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
        if (result.deletedCount === 0)
            return res.status(404).json({ error: 'Task not found' });
        res.json({ message: 'Deleted' });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
