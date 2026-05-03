import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { createServer } from 'http';
import { Server } from 'socket.io';

import authRoutes from './routes/auth';
import userRoutes from './routes/users';
import coupleRoutes from './routes/couples';
import taskRoutes from './routes/tasks';
import financeRoutes from './routes/finances';
import checkinRoutes from './routes/checkins';
import agendaRoutes from './routes/agenda';
import notificationRoutes from './routes/notifications';
import notesRoutes from './routes/notes';
import missionsRoutes from './routes/missions';
import weeklySummaryRoutes from './routes/weeklySummary';
import uploadsRoutes from './routes/uploads';

import { errorHandler } from './middleware/errorHandler';
import { authMiddleware } from './middleware/auth';
import { socketHandler } from './services/socketService';

export function createHttpServer() {
  const app = express();
  const httpServer = createServer(app);
  const io = new Server(httpServer, {
    cors: {
      origin: process.env.FRONTEND_URL || 'http://localhost:3000',
      methods: ['GET', 'POST'],
    },
  });

  const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10),
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100', 10),
    message: {
      error: 'Too many requests from this IP, please try again later.',
    },
  });

  app.use(helmet());
  app.use(
    cors({
      origin: process.env.FRONTEND_URL || 'http://localhost:3000',
      credentials: true,
    }),
  );
  app.use(limiter);
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true }));

  app.get('/health', (req, res) => {
    res.status(200).json({
      status: 'OK',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    });
  });

  app.use('/api/auth', authRoutes);
  app.use('/api/users', authMiddleware, userRoutes);
  app.use('/api/couples', authMiddleware, coupleRoutes);
  app.use('/api/tasks', authMiddleware, taskRoutes);
  app.use('/api/finances', authMiddleware, financeRoutes);
  app.use('/api/checkins', authMiddleware, checkinRoutes);
  app.use('/api/agenda', authMiddleware, agendaRoutes);
  app.use('/api/notifications', authMiddleware, notificationRoutes);
  app.use('/api/notes', authMiddleware, notesRoutes);
  app.use('/api/missions', authMiddleware, missionsRoutes);
  app.use('/api/weekly-summary', authMiddleware, weeklySummaryRoutes);
  app.use('/api/uploads', authMiddleware, uploadsRoutes);

  socketHandler(io);

  app.use('*', (req, res) => {
    res.status(404).json({
      error: 'Route not found',
      path: req.originalUrl,
    });
  });

  app.use(errorHandler);

  return { app, httpServer, io };
}
