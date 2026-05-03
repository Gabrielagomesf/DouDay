import express, { NextFunction, Request, Response } from 'express';
import { coupleMiddleware } from '../middleware/auth';
import { IUser } from '../models/User';
import Task from '../models/Task';
import FinanceBill from '../models/FinanceBill';
import AgendaEvent from '../models/AgendaEvent';
import Checkin from '../models/Checkin';
import Mission from '../models/Mission';
import Couple from '../models/Couple';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const now = new Date();
    const from = new Date(now);
    from.setDate(from.getDate() - 7);

    const [tasksDone, billsPaid, events, checkins, missionsDone, couple] = await Promise.all([
      Task.countDocuments({ coupleId: user.coupleId, status: 'completed', updatedAt: { $gte: from } }),
      FinanceBill.countDocuments({ coupleId: user.coupleId, status: 'paid', updatedAt: { $gte: from } }),
      AgendaEvent.countDocuments({ coupleId: user.coupleId, startAt: { $gte: from } }),
      Checkin.countDocuments({ coupleId: user.coupleId, createdAt: { $gte: from } }),
      Mission.countDocuments({ coupleId: user.coupleId, status: 'completed', updatedAt: { $gte: from } }),
      Couple.findById(user.coupleId).select('relationshipGoal').lean(),
    ]);

    const goalsProgress =
      couple && typeof couple === 'object' && 'relationshipGoal' in couple && couple.relationshipGoal
        ? String(couple.relationshipGoal).substring(0, 120)
        : '—';

    res.json({
      summary: {
        tasksDone,
        billsPaid,
        events,
        checkins,
        missionsDone,
        goalsProgress,
        message: 'Vocês tiveram uma semana bem organizada.',
      },
    });
  } catch (e) {
    next(e);
  }
});

export default router;

