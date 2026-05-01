"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.coupleMiddleware = exports.premiumMiddleware = exports.authMiddleware = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const User_1 = __importDefault(require("../models/User"));
const authMiddleware = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');
        if (!token) {
            return res.status(401).json({
                error: 'Access token is required'
            });
        }
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
        const user = await User_1.default.findById(decoded.userId);
        if (!user) {
            return res.status(401).json({
                error: 'Invalid token - user not found'
            });
        }
        // Check if user is premium for premium features
        if (user.isPremium && user.premiumExpiresAt && user.premiumExpiresAt < new Date()) {
            user.isPremium = false;
            user.premiumExpiresAt = undefined;
            await user.save();
        }
        req.user = user;
        next();
    }
    catch (error) {
        if (error instanceof jsonwebtoken_1.default.JsonWebTokenError) {
            return res.status(401).json({
                error: 'Invalid token'
            });
        }
        if (error instanceof jsonwebtoken_1.default.TokenExpiredError) {
            return res.status(401).json({
                error: 'Token expired'
            });
        }
        return res.status(401).json({
            error: 'Authentication failed'
        });
    }
};
exports.authMiddleware = authMiddleware;
const premiumMiddleware = (req, res, next) => {
    if (!req.user?.isPremium) {
        return res.status(403).json({
            error: 'Premium subscription required'
        });
    }
    next();
};
exports.premiumMiddleware = premiumMiddleware;
const coupleMiddleware = (req, res, next) => {
    if (!req.user?.coupleId || req.user.relationshipStatus !== 'connected') {
        return res.status(403).json({
            error: 'Must be connected to a partner to access this feature'
        });
    }
    next();
};
exports.coupleMiddleware = coupleMiddleware;
