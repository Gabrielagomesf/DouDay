"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const Mission_1 = __importDefault(require("../models/Mission"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
function dayKeyUTC(d) {
    return d.toISOString().substring(0, 10);
}
function weekKeyUTC(d) {
    const date = new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));
    const dayNum = date.getUTCDay() || 7;
    date.setUTCDate(date.getUTCDate() + 4 - dayNum);
    const yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
    const weekNo = Math.ceil((((date.getTime() - yearStart.getTime()) / 86400000) + 1) / 7);
    return `${date.getUTCFullYear()}-${String(weekNo).padStart(2, '0')}`;
}
async function ensureMissions(coupleId) {
    const today = dayKeyUTC(new Date());
    const week = weekKeyUTC(new Date());
    const dailyDefaults = [
        { title: 'Planejem uma refeição juntos', points: 10 },
        { title: 'Façam um check-in hoje', points: 10 },
        { title: 'Organizem uma tarefa atrasada', points: 10 },
    ];
    for (const m of dailyDefaults) {
        const exists = await Mission_1.default.findOne({ coupleId, scope: 'daily', dayKey: today, title: m.title });
        if (!exists) {
            await Mission_1.default.create({ coupleId, scope: 'daily', dayKey: today, title: m.title, points: m.points, status: 'pending' });
        }
    }
    const weeklyDefaults = [
        { title: 'Escolham um momento para conversar', points: 30 },
        { title: 'Organizem as contas da semana', points: 30 },
    ];
    for (const m of weeklyDefaults) {
        const exists = await Mission_1.default.findOne({ coupleId, scope: 'weekly', weekKey: week, title: m.title });
        if (!exists) {
            await Mission_1.default.create({ coupleId, scope: 'weekly', weekKey: week, title: m.title, points: m.points, status: 'pending' });
        }
    }
}
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        await ensureMissions(user.coupleId);
        const today = dayKeyUTC(new Date());
        const week = weekKeyUTC(new Date());
        const daily = await Mission_1.default.find({ coupleId: user.coupleId, scope: 'daily', dayKey: today }).sort({ createdAt: 1 });
        const weekly = await Mission_1.default.find({ coupleId: user.coupleId, scope: 'weekly', weekKey: week }).sort({ createdAt: 1 });
        res.json({ daily, weekly });
    }
    catch (e) {
        next(e);
    }
});
router.patch('/:id/status', async (req, res, next) => {
    try {
        const user = req.user;
        const { status } = req.body || {};
        if (status !== 'pending' && status !== 'completed')
            return res.status(400).json({ error: 'Invalid status' });
        const mission = await Mission_1.default.findOne({ _id: req.params.id, coupleId: user.coupleId });
        if (!mission)
            return res.status(404).json({ error: 'Mission not found' });
        mission.status = status;
        mission.completedAt = status === 'completed' ? new Date() : undefined;
        await mission.save();
        res.json({ mission });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
