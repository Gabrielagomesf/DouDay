"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const crypto_1 = __importDefault(require("crypto"));
const User_1 = __importDefault(require("../models/User"));
const Couple_1 = __importDefault(require("../models/Couple"));
const emailService_1 = require("../services/emailService");
const jwt_1 = require("../utils/jwt");
const validation_1 = require("../middleware/validation");
const router = express_1.default.Router();
const serializeUser = (user) => ({
    id: user._id,
    name: user.name,
    email: user.email,
    avatar: user.avatar,
    relationshipStatus: user.relationshipStatus,
    partnerId: user.partnerId,
    partnerName: user.partnerName,
    coupleId: user.coupleId,
    isPremium: user.isPremium,
    premiumExpiresAt: user.premiumExpiresAt,
    lastLoginAt: user.lastLoginAt,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
});
// Register
router.post('/register', validation_1.validateAuth.register, async (req, res, next) => {
    try {
        const { name, email, password } = req.body;
        // Check if user already exists
        const existingUser = await User_1.default.findOne({ email });
        if (existingUser) {
            return res.status(400).json({
                error: 'User already exists with this email'
            });
        }
        // Create new user
        const user = new User_1.default({
            name,
            email,
            password,
            relationshipStatus: 'single'
        });
        await user.save();
        // Generate tokens
        const { accessToken, refreshToken } = (0, jwt_1.generateTokens)(user._id.toString());
        // Update last login
        user.lastLoginAt = new Date();
        await user.save();
        res.status(201).json({
            message: 'User registered successfully',
            user: serializeUser(user),
            access_token: accessToken,
            refresh_token: refreshToken
        });
    }
    catch (error) {
        next(error);
    }
});
// Login
router.post('/login', validation_1.validateAuth.login, async (req, res, next) => {
    try {
        const { email, password } = req.body;
        // Find user with password
        const user = await User_1.default.findByEmail(email);
        if (!user) {
            return res.status(401).json({
                error: 'Invalid email or password'
            });
        }
        // Check password
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            return res.status(401).json({
                error: 'Invalid email or password'
            });
        }
        // Generate tokens
        const { accessToken, refreshToken } = (0, jwt_1.generateTokens)(user._id.toString());
        // Update last login
        user.lastLoginAt = new Date();
        await user.save();
        // Get couple info if connected
        let coupleInfo = null;
        if (user.relationshipStatus === 'connected' && user.coupleId) {
            coupleInfo = await Couple_1.default.findById(user.coupleId)
                .populate('user1Id', 'name email avatar')
                .populate('user2Id', 'name email avatar');
        }
        res.json({
            message: 'Login successful',
            user: serializeUser(user),
            couple: coupleInfo,
            access_token: accessToken,
            refresh_token: refreshToken
        });
    }
    catch (error) {
        next(error);
    }
});
// Refresh Token
router.post('/refresh', async (req, res, next) => {
    try {
        const { refresh_token } = req.body;
        if (!refresh_token) {
            return res.status(401).json({
                error: 'Refresh token is required'
            });
        }
        // Verify refresh token
        const decoded = (0, jwt_1.verifyRefreshToken)(refresh_token);
        if (!decoded) {
            return res.status(401).json({
                error: 'Invalid or expired refresh token'
            });
        }
        // Find user
        const user = await User_1.default.findById(decoded.userId);
        if (!user) {
            return res.status(401).json({
                error: 'User not found'
            });
        }
        // Generate new tokens
        const { accessToken, refreshToken } = (0, jwt_1.generateTokens)(user._id.toString());
        res.json({
            access_token: accessToken,
            refresh_token: refreshToken
        });
    }
    catch (error) {
        next(error);
    }
});
// Get Profile
router.get('/profile', async (req, res, next) => {
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
            return res.status(404).json({
                error: 'User not found'
            });
        }
        // Get couple info if connected
        let coupleInfo = null;
        if (user.relationshipStatus === 'connected' && user.coupleId) {
            coupleInfo = await Couple_1.default.findById(user.coupleId)
                .populate('user1Id', 'name email avatar')
                .populate('user2Id', 'name email avatar');
        }
        res.json({
            user: serializeUser(user),
            couple: coupleInfo
        });
    }
    catch (error) {
        next(error);
    }
});
// Update Profile
router.put('/profile', async (req, res, next) => {
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
            return res.status(404).json({
                error: 'User not found'
            });
        }
        const { name, email, avatar } = req.body;
        if (name)
            user.name = name;
        if (email)
            user.email = email;
        if (avatar)
            user.avatar = avatar;
        await user.save();
        res.json({
            message: 'Profile updated successfully',
            user: serializeUser(user)
        });
    }
    catch (error) {
        next(error);
    }
});
// Change Password
router.put('/password', async (req, res, next) => {
    try {
        const token = req.headers.authorization?.replace('Bearer ', '');
        if (!token) {
            return res.status(401).json({
                error: 'Access token is required'
            });
        }
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
        const user = await User_1.default.findById(decoded.userId).select('+password');
        if (!user) {
            return res.status(404).json({
                error: 'User not found'
            });
        }
        const { current_password, new_password } = req.body;
        // Verify current password
        const isCurrentPasswordValid = await user.comparePassword(current_password);
        if (!isCurrentPasswordValid) {
            return res.status(400).json({
                error: 'Current password is incorrect'
            });
        }
        // Update password
        user.password = new_password;
        await user.save();
        res.json({
            message: 'Password changed successfully'
        });
    }
    catch (error) {
        next(error);
    }
});
// Forgot Password
router.post('/forgot-password', async (req, res, next) => {
    try {
        const { email } = req.body;
        const user = await User_1.default.findOne({ email });
        if (!user) {
            return res.status(404).json({
                error: 'User not found with this email'
            });
        }
        // Generate and store 6-digit verification code
        const verificationCode = String(Math.floor(100000 + Math.random() * 900000));
        const codeHash = crypto_1.default.createHash('sha256').update(verificationCode).digest('hex');
        user.passwordResetCodeHash = codeHash;
        user.passwordResetCodeExpiresAt = new Date(Date.now() + 10 * 60 * 1000);
        await user.save();
        // Send email
        await (0, emailService_1.sendEmail)({
            to: email,
            subject: 'Código de verificação - DuoDay',
            template: 'password-reset-code',
            data: {
                name: user.name,
                code: verificationCode,
            }
        });
        res.json({
            message: 'Verification code sent successfully'
        });
    }
    catch (error) {
        next(error);
    }
});
// Verify reset code
router.post('/verify-reset-code', async (req, res, next) => {
    try {
        const { email, code } = req.body;
        if (!email || !code) {
            return res.status(400).json({ error: 'Email and code are required' });
        }
        const user = await User_1.default.findOne({ email }).select('+passwordResetCodeHash');
        if (!user || !user.passwordResetCodeHash || !user.passwordResetCodeExpiresAt) {
            return res.status(400).json({ error: 'Invalid or expired verification code' });
        }
        if (user.passwordResetCodeExpiresAt.getTime() < Date.now()) {
            return res.status(400).json({ error: 'Invalid or expired verification code' });
        }
        const codeHash = crypto_1.default.createHash('sha256').update(String(code)).digest('hex');
        if (codeHash !== user.passwordResetCodeHash) {
            return res.status(400).json({ error: 'Invalid or expired verification code' });
        }
        const resetToken = jsonwebtoken_1.default.sign({ userId: user._id, type: 'password_reset' }, process.env.JWT_SECRET, { expiresIn: '15m' });
        res.json({ message: 'Code verified successfully', reset_token: resetToken });
    }
    catch (error) {
        next(error);
    }
});
// Reset Password
router.post('/reset-password', async (req, res, next) => {
    try {
        const { token, password } = req.body;
        // Verify token
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
        if (decoded.type !== 'password_reset') {
            return res.status(400).json({
                error: 'Invalid reset token'
            });
        }
        const user = await User_1.default.findById(decoded.userId);
        if (!user) {
            return res.status(404).json({
                error: 'User not found'
            });
        }
        // Update password
        user.password = password;
        user.passwordResetCodeHash = null;
        user.passwordResetCodeExpiresAt = null;
        await user.save();
        res.json({
            message: 'Password reset successfully'
        });
    }
    catch (error) {
        next(error);
    }
});
// Logout
router.post('/logout', async (req, res) => {
    res.json({
        message: 'Logout successful'
    });
});
exports.default = router;
