import express, { NextFunction, Request, Response } from 'express';
import { coupleMiddleware } from '../middleware/auth';
import { IUser } from '../models/User';
import Note from '../models/Note';
import { requireMongoIdParam, sanitizeClientBody } from '../utils/routeHelpers';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { q, category, pinned } = req.query as any;
    const query: any = { coupleId: user.coupleId };
    if (category) query.category = category;
    if (pinned === 'true') query.isPinned = true;
    if (q) query.title = { $regex: String(q), $options: 'i' };

    const notes = await Note.find(query).sort({ isPinned: -1, updatedAt: -1 }).limit(500);
    res.json({ notes });
  } catch (e) {
    next(e);
  }
});

router.post('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { title, content, category, isPinned } = req.body || {};
    if (!title || typeof title !== 'string') return res.status(400).json({ error: 'Title is required' });

    const note = await Note.create({
      coupleId: user.coupleId,
      title,
      content: content ?? '',
      category,
      isPinned: !!isPinned,
      createdBy: user._id,
    });
    res.status(201).json({ note });
  } catch (e) {
    next(e);
  }
});

router.get('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const note = await Note.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.json({ note });
  } catch (e) {
    next(e);
  }
});

router.put('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const updates = sanitizeClientBody(req.body || {});
    const note = await Note.findOneAndUpdate(
      { _id: req.params.id, coupleId: user.coupleId },
      { $set: updates },
      { new: true, runValidators: true }
    );
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.json({ note });
  } catch (e) {
    next(e);
  }
});

router.patch('/:id/pin', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const { isPinned } = req.body || {};
    const note = await Note.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!note) return res.status(404).json({ error: 'Note not found' });
    note.isPinned = !!isPinned;
    await note.save();
    res.json({ note });
  } catch (e) {
    next(e);
  }
});

router.delete('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    if (!requireMongoIdParam(req.params.id, res)) return;
    const user = req.user!;
    const result = await Note.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
    if (result.deletedCount === 0) return res.status(404).json({ error: 'Note not found' });
    res.json({ message: 'Deleted' });
  } catch (e) {
    next(e);
  }
});

export default router;

