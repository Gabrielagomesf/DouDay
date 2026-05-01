import express, { NextFunction, Request, Response } from 'express';
import { coupleMiddleware } from '../middleware/auth';
import { IUser } from '../models/User';
import Notification from '../models/Notification';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { type, unread } = req.query as any;
    const query: any = { coupleId: user.coupleId };
    if (type) query.type = type;
    if (unread === 'true') query.isRead = false;
    const notifications = await Notification.find(query).sort({ createdAt: -1 }).limit(500);
    res.json({ notifications });
  } catch (e) {
    next(e);
  }
});

router.post('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  // Optional: allow server to create notifications (internal/testing)
  try {
    const user = req.user!;
    const { type, title, body, data } = req.body || {};
    if (!title) return res.status(400).json({ error: 'title is required' });
    const n = await Notification.create({
      coupleId: user.coupleId,
      type,
      title,
      body,
      data,
      isRead: false,
    });
    res.status(201).json({ notification: n });
  } catch (e) {
    next(e);
  }
});

router.patch('/:id/read', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { isRead } = req.body || {};
    const n = await Notification.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!n) return res.status(404).json({ error: 'Notification not found' });
    n.isRead = isRead === undefined ? true : !!isRead;
    await n.save();
    res.json({ notification: n });
  } catch (e) {
    next(e);
  }
});

router.delete('/clear', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    await Notification.deleteMany({ coupleId: user.coupleId });
    res.json({ message: 'Cleared' });
  } catch (e) {
    next(e);
  }
});

export default router;
