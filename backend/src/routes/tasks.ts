import express, { NextFunction, Request, Response } from 'express';
import Task from '../models/Task';
import { IUser } from '../models/User';
import { coupleMiddleware } from '../middleware/auth';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

router.use(coupleMiddleware);

function normalizeDateOnly(dateStr?: string) {
  if (!dateStr) return undefined;
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return undefined;
  d.setHours(0, 0, 0, 0);
  return d;
}

// List tasks with filters
router.get('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { filter, status, assignee, category, priority, q } = req.query as any;

    const query: any = { coupleId: user.coupleId };

    if (status) query.status = status;
    if (assignee) query.assignee = assignee;
    if (category) query.category = category;
    if (priority) query.priority = priority;
    if (q) query.title = { $regex: String(q), $options: 'i' };

    const today = normalizeDateOnly(new Date().toISOString());
    if (filter === 'today' && today) {
      const end = new Date(today);
      end.setDate(end.getDate() + 1);
      query.dueAt = { $gte: today, $lt: end };
    }
    if (filter === 'overdue' && today) {
      query.dueAt = { $lt: today };
      query.status = 'pending';
    }
    if (filter === 'completed') {
      query.status = 'completed';
    }

    const tasks = await Task.find(query).sort({ dueAt: 1, createdAt: -1 }).limit(500);
    res.json({ tasks });
  } catch (e) {
    next(e);
  }
});

// Create task
router.post('/', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const {
      title,
      description,
      assignee,
      dueAt,
      priority,
      category,
      repeat,
      reminder,
    } = req.body || {};

    if (!title || typeof title !== 'string') {
      return res.status(400).json({ error: 'Title is required' });
    }

    const task = await Task.create({
      coupleId: user.coupleId,
      title,
      description,
      assignee,
      dueAt: dueAt ? new Date(dueAt) : undefined,
      priority,
      category,
      repeat,
      reminder,
      createdBy: user._id,
      status: 'pending',
    });

    res.status(201).json({ task });
  } catch (e) {
    next(e);
  }
});

// Get task
router.get('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const task = await Task.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!task) return res.status(404).json({ error: 'Task not found' });
    res.json({ task });
  } catch (e) {
    next(e);
  }
});

// Update task
router.put('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const updates: any = { ...req.body };
    if (updates.dueAt) updates.dueAt = new Date(updates.dueAt);

    const task = await Task.findOneAndUpdate(
      { _id: req.params.id, coupleId: user.coupleId },
      { $set: updates },
      { new: true }
    );
    if (!task) return res.status(404).json({ error: 'Task not found' });
    res.json({ task });
  } catch (e) {
    next(e);
  }
});

// Mark completed / uncompleted
router.patch('/:id/status', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const { status } = req.body || {};
    if (status !== 'pending' && status !== 'completed') {
      return res.status(400).json({ error: 'Invalid status' });
    }

    const task = await Task.findOne({ _id: req.params.id, coupleId: user.coupleId });
    if (!task) return res.status(404).json({ error: 'Task not found' });

    task.status = status;
    task.completedAt = status === 'completed' ? new Date() : undefined;
    await task.save();

    res.json({ task });
  } catch (e) {
    next(e);
  }
});

// Delete task
router.delete('/:id', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const user = req.user!;
    const result = await Task.deleteOne({ _id: req.params.id, coupleId: user.coupleId });
    if (result.deletedCount === 0) return res.status(404).json({ error: 'Task not found' });
    res.json({ message: 'Deleted' });
  } catch (e) {
    next(e);
  }
});

export default router;
