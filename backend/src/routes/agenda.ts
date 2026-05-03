import express, { NextFunction, Request, Response } from 'express';
import { coupleMiddleware } from '../middleware/auth';
import { IUser } from '../models/User';
import AgendaEvent from '../models/AgendaEvent';
import { requireMongoIdParam, sanitizeClientBody } from '../utils/routeHelpers';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

// List events (optional range)
router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { from, to, participants, q } = req.query as any;

    const query: any = { coupleId: user.coupleId };
    if (participants) query.participants = participants;
    if (q) query.title = { $regex: String(q), $options: 'i' };

    if (from || to) {
      query.startAt = {};
      if (from) query.startAt.$gte = new Date(from);
      if (to) query.startAt.$lte = new Date(to);
    }

    const events = await AgendaEvent.find(query).sort({ startAt: 1 }).limit(500);
    res.json({ events });
  } catch (e) {
    next(e);
  }
});

// Create event
router.post('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const {
      title,
      description,
      location,
      participants,
      startAt,
      endAt,
      repeat,
      reminder,
    } = req.body || {};

    if (!title || typeof title !== 'string') return res.status(400).json({ error: 'Title is required' });
    if (!startAt || !endAt) return res.status(400).json({ error: 'startAt and endAt are required' });

    const event = await AgendaEvent.create({
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
  } catch (e) {
    next(e);
  }
});

// Get event
router.get('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const event = await AgendaEvent.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!event) return res.status(404).json({ error: 'Event not found' });
    res.json({ event });
  } catch (e) {
    next(e);
  }
});

// Update event
router.put('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const updates: Record<string, unknown> = sanitizeClientBody(req.body || {});
    if (updates.startAt) updates.startAt = new Date(updates.startAt as string);
    if (updates.endAt) updates.endAt = new Date(updates.endAt as string);

    const event = await AgendaEvent.findOneAndUpdate(
      { _id: req.params.id, coupleId: user.coupleId },
      { $set: updates },
      { new: true, runValidators: true }
    );
    if (!event) return res.status(404).json({ error: 'Event not found' });
    res.json({ event });
  } catch (e) {
    next(e);
  }
});

// Delete event
router.delete('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const result = await AgendaEvent.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
    if (result.deletedCount === 0) return res.status(404).json({ error: 'Event not found' });
    res.json({ message: 'Deleted' });
  } catch (e) {
    next(e);
  }
});

export default router;
