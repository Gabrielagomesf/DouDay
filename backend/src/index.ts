import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import dotenv from 'dotenv';
import { createServer } from 'http';
import { Server } from 'socket.io';
import mongoose from 'mongoose';

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
import FirebaseService from './services/firebaseService';

dotenv.config();

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    methods: ["GET", "POST"]
  }
});

const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/duoday';

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000'), // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'), // limit each IP to 100 requests per windowMs
  message: {
    error: 'Too many requests from this IP, please try again later.'
  }
});

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || "http://localhost:3000",
  credentials: true
}));
app.use(limiter);
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// API Routes
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

// Socket.io
socketHandler(io);

// Error handling
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.originalUrl
  });
});

// Initialize Firebase
try {
  FirebaseService.getInstance();
  console.log('✅ Firebase Admin initialized');
} catch (error) {
  console.error('❌ Firebase initialization failed:', error);
}

// Database connection
mongoose.connect(MONGODB_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB');
    server.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🔥 Firebase Project: ${process.env.FIREBASE_PROJECT_ID}`);
    });
  })
  .catch((error) => {
    console.error('❌ Database connection error:', error);
    process.exit(1);
  });

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    mongoose.connection.close().then(() => {
      console.log('MongoDB connection closed');
      process.exit(0);
    }).catch((err) => {
      console.error('Error closing MongoDB connection:', err);
      process.exit(1);
    });
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    mongoose.connection.close().then(() => {
      console.log('MongoDB connection closed');
      process.exit(0);
    }).catch((err) => {
      console.error('Error closing MongoDB connection:', err);
      process.exit(1);
    });
  });
});

export default app;
