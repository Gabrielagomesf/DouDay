"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const Notification_1 = __importDefault(require("../models/Notification"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { type, unread } = req.query;
        const query = { coupleId: user.coupleId };
        if (type)
            query.type = type;
        if (unread === 'true')
            query.isRead = false;
        const notifications = await Notification_1.default.find(query).sort({ createdAt: -1 }).limit(500);
        res.json({ notifications });
    }
    catch (e) {
        next(e);
    }
});
router.post('/', async (req, res, next) => {
    // Optional: allow server to create notifications (internal/testing)
    try {
        const user = req.user;
        const { type, title, body, data } = req.body || {};
        if (!title)
            return res.status(400).json({ error: 'title is required' });
        const n = await Notification_1.default.create({
            coupleId: user.coupleId,
            type,
            title,
            body,
            data,
            isRead: false,
        });
        res.status(201).json({ notification: n });
    }
    catch (e) {
        next(e);
    }
});
router.patch('/:id/read', async (req, res, next) => {
    try {
        const user = req.user;
        const { isRead } = req.body || {};
        const n = await Notification_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!n)
            return res.status(404).json({ error: 'Notification not found' });
        n.isRead = isRead === undefined ? true : !!isRead;
        await n.save();
        res.json({ notification: n });
    }
    catch (e) {
        next(e);
    }
});
router.delete('/clear', async (req, res, next) => {
    try {
        const user = req.user;
        await Notification_1.default.deleteMany({ coupleId: user.coupleId });
        res.json({ message: 'Cleared' });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
