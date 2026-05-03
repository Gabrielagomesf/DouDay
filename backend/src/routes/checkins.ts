import express, { NextFunction, Request, Response } from 'express';
import { coupleMiddleware } from '../middleware/auth';
import { IUser } from '../models/User';
import Checkin from '../models/Checkin';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

const ALLOWED_MOODS = ['very_good', 'good', 'neutral', 'tired', 'stressed', 'sad'] as const;

function dayKeyUTC(d: Date) {
  return d.toISOString().substring(0, 10);
}

// Submit check-in for today
router.post('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { mood, comment } = req.body || {};
    if (!mood || typeof mood !== 'string') return res.status(400).json({ error: 'Mood is required' });
    if (!(ALLOWED_MOODS as readonly string[]).includes(mood)) {
      return res.status(400).json({ error: 'Invalid mood', allowed: ALLOWED_MOODS });
    }

    const todayKey = dayKeyUTC(new Date());

    const checkin = await Checkin.findOneAndUpdate(
      { coupleId: user.coupleId, userId: user._id, dayKey: todayKey },
      { $set: { mood, comment: comment ?? '' } },
      { upsert: true, new: true, runValidators: true, setDefaultsOnInsert: true }
    );

    res.status(201).json({ checkin });
  } catch (e) {
    next(e);
  }
});

// List checkins (optional range)
router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { from, to } = req.query as any;
    const query: any = { coupleId: user.coupleId };
    if (from || to) {
      query.dayKey = {};
      if (from) query.dayKey.$gte = String(from).substring(0, 10);
      if (to) query.dayKey.$lte = String(to).substring(0, 10);
    }
    const checkins = await Checkin.find(query).sort({ dayKey: -1 }).limit(1000);
    res.json({ checkins });
  } catch (e) {
    next(e);
  }
});

export default router;
