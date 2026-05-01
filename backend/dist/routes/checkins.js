"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const Checkin_1 = __importDefault(require("../models/Checkin"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
function dayKeyUTC(d) {
    return d.toISOString().substring(0, 10);
}
// Submit check-in for today
router.post('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { mood, comment } = req.body || {};
        if (!mood)
            return res.status(400).json({ error: 'Mood is required' });
        const todayKey = dayKeyUTC(new Date());
        const checkin = await Checkin_1.default.findOneAndUpdate({ coupleId: user.coupleId, userId: user._id, dayKey: todayKey }, { $set: { mood, comment: comment ?? '' } }, { upsert: true, new: true });
        res.status(201).json({ checkin });
    }
    catch (e) {
        next(e);
    }
});
// List checkins (optional range)
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const { from, to } = req.query;
        const query = { coupleId: user.coupleId };
        if (from || to) {
            query.dayKey = {};
            if (from)
                query.dayKey.$gte = String(from).substring(0, 10);
            if (to)
                query.dayKey.$lte = String(to).substring(0, 10);
        }
        const checkins = await Checkin_1.default.find(query).sort({ dayKey: -1 }).limit(1000);
        res.json({ checkins });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
