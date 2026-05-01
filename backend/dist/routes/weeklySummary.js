"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const auth_1 = require("../middleware/auth");
const Task_1 = __importDefault(require("../models/Task"));
const FinanceBill_1 = __importDefault(require("../models/FinanceBill"));
const AgendaEvent_1 = __importDefault(require("../models/AgendaEvent"));
const Checkin_1 = __importDefault(require("../models/Checkin"));
const Mission_1 = __importDefault(require("../models/Mission"));
const router = express_1.default.Router();
router.use(auth_1.coupleMiddleware);
router.get('/', async (req, res, next) => {
    try {
        const user = req.user;
        const now = new Date();
        const from = new Date(now);
        from.setDate(from.getDate() - 7);
        const [tasksDone, billsPaid, events, checkins, missionsDone] = await Promise.all([
            Task_1.default.countDocuments({ coupleId: user.coupleId, status: 'completed', updatedAt: { $gte: from } }),
            FinanceBill_1.default.countDocuments({ coupleId: user.coupleId, status: 'paid', updatedAt: { $gte: from } }),
            AgendaEvent_1.default.countDocuments({ coupleId: user.coupleId, startAt: { $gte: from } }),
            Checkin_1.default.countDocuments({ coupleId: user.coupleId, createdAt: { $gte: from } }),
            Mission_1.default.countDocuments({ coupleId: user.coupleId, status: 'completed', updatedAt: { $gte: from } }),
        ]);
        res.json({
            summary: {
                tasksDone,
                billsPaid,
                events,
                checkins,
                missionsDone,
                message: 'Vocês tiveram uma semana bem organizada.',
            },
        });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
