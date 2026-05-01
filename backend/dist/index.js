"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const dotenv_1 = __importDefault(require("dotenv"));
const http_1 = require("http");
const socket_io_1 = require("socket.io");
const mongoose_1 = __importDefault(require("mongoose"));
const auth_1 = __importDefault(require("./routes/auth"));
const users_1 = __importDefault(require("./routes/users"));
const couples_1 = __importDefault(require("./routes/couples"));
const tasks_1 = __importDefault(require("./routes/tasks"));
const finances_1 = __importDefault(require("./routes/finances"));
const checkins_1 = __importDefault(require("./routes/checkins"));
const agenda_1 = __importDefault(require("./routes/agenda"));
const notifications_1 = __importDefault(require("./routes/notifications"));
const notes_1 = __importDefault(require("./routes/notes"));
const missions_1 = __importDefault(require("./routes/missions"));
const weeklySummary_1 = __importDefault(require("./routes/weeklySummary"));
const uploads_1 = __importDefault(require("./routes/uploads"));
const errorHandler_1 = require("./middleware/errorHandler");
const auth_2 = require("./middleware/auth");
const socketService_1 = require("./services/socketService");
const firebaseService_1 = __importDefault(require("./services/firebaseService"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const server = (0, http_1.createServer)(app);
const io = new socket_io_1.Server(server, {
    cors: {
        origin: process.env.FRONTEND_URL || "http://localhost:3000",
        methods: ["GET", "POST"]
    }
});
const PORT = process.env.PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/duoday';
// Rate limiting
const limiter = (0, express_rate_limit_1.default)({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000'), // 15 minutes
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'), // limit each IP to 100 requests per windowMs
    message: {
        error: 'Too many requests from this IP, please try again later.'
    }
});
// Middleware
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true
}));
app.use(limiter);
app.use(express_1.default.json({ limit: '10mb' }));
app.use(express_1.default.urlencoded({ extended: true }));
// Health check
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'OK',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});
// API Routes
app.use('/api/auth', auth_1.default);
app.use('/api/users', auth_2.authMiddleware, users_1.default);
app.use('/api/couples', auth_2.authMiddleware, couples_1.default);
app.use('/api/tasks', auth_2.authMiddleware, tasks_1.default);
app.use('/api/finances', auth_2.authMiddleware, finances_1.default);
app.use('/api/checkins', auth_2.authMiddleware, checkins_1.default);
app.use('/api/agenda', auth_2.authMiddleware, agenda_1.default);
app.use('/api/notifications', auth_2.authMiddleware, notifications_1.default);
app.use('/api/notes', auth_2.authMiddleware, notes_1.default);
app.use('/api/missions', auth_2.authMiddleware, missions_1.default);
app.use('/api/weekly-summary', auth_2.authMiddleware, weeklySummary_1.default);
app.use('/api/uploads', auth_2.authMiddleware, uploads_1.default);
// Socket.io
(0, socketService_1.socketHandler)(io);
// Error handling
app.use(errorHandler_1.errorHandler);
// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({
        error: 'Route not found',
        path: req.originalUrl
    });
});
// Initialize Firebase
try {
    firebaseService_1.default.getInstance();
    console.log('✅ Firebase Admin initialized');
}
catch (error) {
    console.error('❌ Firebase initialization failed:', error);
}
// Database connection
mongoose_1.default.connect(MONGODB_URI)
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
        mongoose_1.default.connection.close().then(() => {
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
        mongoose_1.default.connection.close().then(() => {
            console.log('MongoDB connection closed');
            process.exit(0);
        }).catch((err) => {
            console.error('Error closing MongoDB connection:', err);
            process.exit(1);
        });
    });
});
exports.default = app;
