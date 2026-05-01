"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const AgendaEvent_1 = __importDefault(require("../models/AgendaEvent"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
// List events (optional range)
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { from, to, participants, q } = req.query;
        const query = { coupleId: user.coupleId };
        if (participants)
            query.participants = participants;
        if (q)
            query.title = { $regex: String(q), $options: 'i' };
        if (from || to) {
            query.startAt = {};
            if (from)
                query.startAt.$gte = new Date(from);
            if (to)
                query.startAt.$lte = new Date(to);
        }
        const events = await AgendaEvent_1.default.find(query).sort({ startAt: 1 }).limit(500);
        res.json({ events });
    }
    catch (e) {
        next(e);
    }
});
// Create event
router.post('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { title, description, location, participants, startAt, endAt, repeat, reminder, } = req.body || {};
        if (!title || typeof title !== 'string')
            return res.status(400).json({ error: 'Title is required' });
        if (!startAt || !endAt)
            return res.status(400).json({ error: 'startAt and endAt are required' });
        const event = await AgendaEvent_1.default.create({
            coupleId: user.coupleId,
            title,
            description,
            location,
            participants,
            startAt: new Date(startAt),
            endAt: new Date(endAt),
            repeat,
            reminder,
            createdBy: user._id,
        });
        res.status(201).json({ event });
    }
    catch (e) {
        next(e);
    }
});
// Get event
router.get('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const event = await AgendaEvent_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!event)
            return res.status(404).json({ error: 'Event not found' });
        res.json({ event });
    }
    catch (e) {
        next(e);
    }
});
// Update event
router.put('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const updates = { ...req.body };
        if (updates.startAt)
            updates.startAt = new Date(updates.startAt);
        if (updates.endAt)
            updates.endAt = new Date(updates.endAt);
        const event = await AgendaEvent_1.default.findOneAndUpdate({ _id: req.params.id, coupleId: user.coupleId }, { $set: updates }, { new: true });
        if (!event)
            return res.status(404).json({ error: 'Event not found' });
        res.json({ event });
    }
    catch (e) {
        next(e);
    }
});
// Delete event
router.delete('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const result = await AgendaEvent_1.default.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
        if (result.deletedCount === 0)
            return res.status(404).json({ error: 'Event not found' });
        res.json({ message: 'Deleted' });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
