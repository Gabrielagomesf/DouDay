import dotenv from 'dotenv';
import mongoose from 'mongoose';

import { createHttpServer } from './app';
import FirebaseService from './services/firebaseService';

dotenv.config();

const { httpServer } = createHttpServer();

const PORT = Number(process.env.PORT) || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/duoday';

function initFirebase(): void {
  try {
    FirebaseService.getInstance();
    console.log('✅ Firebase Admin initialized');
  } catch (error) {
    console.error('❌ Firebase initialization failed:', error);
  }
}

function gracefulShutdown(signal: string): () => void {
  return () => {
    console.log(`${signal} received, shutting down gracefully`);
    httpServer.close(() => {
      mongoose.connection
        .close()
        .then(() => {
          console.log('MongoDB connection closed');
          process.exit(0);
        })
        .catch((err) => {
          console.error('Error closing MongoDB connection:', err);
          process.exit(1);
        });
    });
  };
}

const mongoTimeoutMs = Number(process.env.MONGODB_SERVER_SELECTION_TIMEOUT_MS) || 15000;

mongoose
  .connect(MONGODB_URI, {
    serverSelectionTimeoutMS: mongoTimeoutMs,
  })
  .then(() => {
    console.log('✅ Connected to MongoDB');
    initFirebase();
    httpServer.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🔥 Firebase Project: ${process.env.FIREBASE_PROJECT_ID}`);
    });
  })
  .catch((error) => {
    console.error('❌ Database connection error:', error);
    process.exit(1);
  });

process.on('SIGTERM', gracefulShutdown('SIGTERM'));
process.on('SIGINT', gracefulShutdown('SIGINT'));
