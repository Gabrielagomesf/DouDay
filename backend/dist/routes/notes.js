"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const Note_1 = __importDefault(require("../models/Note"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { q, category, pinned } = req.query;
        const query = { coupleId: user.coupleId };
        if (category)
            query.category = category;
        if (pinned === 'true')
            query.isPinned = true;
        if (q)
            query.title = { $regex: String(q), $options: 'i' };
        const notes = await Note_1.default.find(query).sort({ isPinned: -1, updatedAt: -1 }).limit(500);
        res.json({ notes });
    }
    catch (e) {
        next(e);
    }
});
router.post('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { title, content, category, isPinned } = req.body || {};
        if (!title || typeof title !== 'string')
            return res.status(400).json({ error: 'Title is required' });
        const note = await Note_1.default.create({
            coupleId: user.coupleId,
            title,
            content: content ?? '',
            category,
            isPinned: !!isPinned,
            createdBy: user._id,
        });
        res.status(201).json({ note });
    }
    catch (e) {
        next(e);
    }
});
router.get('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const note = await Note_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!note)
            return res.status(404).json({ error: 'Note not found' });
        res.json({ note });
    }
    catch (e) {
        next(e);
    }
});
router.put('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const updates = { ...req.body };
        const note = await Note_1.default.findOneAndUpdate({ _id: req.params.id, coupleId: user.coupleId }, { $set: updates }, { new: true });
        if (!note)
            return res.status(404).json({ error: 'Note not found' });
        res.json({ note });
    }
    catch (e) {
        next(e);
    }
});
router.patch('/:id/pin', async (req, res, next) => {
    try {
        const user = req.user;
        const { isPinned } = req.body || {};
        const note = await Note_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!note)
            return res.status(404).json({ error: 'Note not found' });
        note.isPinned = !!isPinned;
        await note.save();
        res.json({ note });
    }
    catch (e) {
        next(e);
    }
});
router.delete('/:id', async (req, res, next) => {
    try {
        const user = req.user;
        const result = await Note_1.default.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
        if (result.deletedCount === 0)
            return res.status(404).json({ error: 'Note not found' });
        res.json({ message: 'Deleted' });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
