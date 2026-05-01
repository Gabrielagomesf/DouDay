import express, { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import User, { IUser } from '../models/User';
import Couple from '../models/Couple';
import { sendEmail } from '../services/emailService';
import { generateTokens, verifyRefreshToken } from '../utils/jwt';
import { validateAuth } from '../middleware/validation';

const router = express.Router();

interface AuthRequest extends Request {
  user?: IUser;
}

const serializeUser = (user: IUser) => ({
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
router.post('/register', validateAuth.register, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { name, email, password } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        error: 'User already exists with this email'
      });
    }

    // Create new user
    const user = new User({
      name,
      email,
      password,
      relationshipStatus: 'single'
    });

    await user.save();

    // Generate tokens
    const { accessToken, refreshToken } = generateTokens(user._id.toString());

    // Update last login
    user.lastLoginAt = new Date();
    await user.save();

    res.status(201).json({
      message: 'User registered successfully',
      user: serializeUser(user),
      access_token: accessToken,
      refresh_token: refreshToken
    });
  } catch (error) {
    next(error);
  }
});

// Login
router.post('/login', validateAuth.login, async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;

    // Find user with password
    const user = await User.findByEmail(email);
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
    const { accessToken, refreshToken } = generateTokens(user._id.toString());

    // Update last login
    user.lastLoginAt = new Date();
    await user.save();

    // Get couple info if connected
    let coupleInfo = null;
    if (user.relationshipStatus === 'connected' && user.coupleId) {
      coupleInfo = await Couple.findById(user.coupleId)
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
  } catch (error) {
    next(error);
  }
});

// Refresh Token
router.post('/refresh', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { refresh_token } = req.body;

    if (!refresh_token) {
      return res.status(401).json({
        error: 'Refresh token is required'
      });
    }

    // Verify refresh token
    const decoded = verifyRefreshToken(refresh_token);
    if (!decoded) {
      return res.status(401).json({
        error: 'Invalid or expired refresh token'
      });
    }

    // Find user
    const user = await User.findById(decoded.userId);
    if (!user) {
      return res.status(401).json({
        error: 'User not found'
      });
    }

    // Generate new tokens
    const { accessToken, refreshToken } = generateTokens(user._id.toString());

    res.json({
      access_token: accessToken,
      refresh_token: refreshToken
    });
  } catch (error) {
    next(error);
  }
});

// Get Profile
router.get('/profile', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    if (!token) {
      return res.status(401).json({
        error: 'Access token is required'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
    const user = await User.findById(decoded.userId);

    if (!user) {
      return res.status(404).json({
        error: 'User not found'
      });
    }

    // Get couple info if connected
    let coupleInfo = null;
    if (user.relationshipStatus === 'connected' && user.coupleId) {
      coupleInfo = await Couple.findById(user.coupleId)
        .populate('user1Id', 'name email avatar')
        .populate('user2Id', 'name email avatar');
    }

    res.json({
      user: serializeUser(user),
      couple: coupleInfo
    });
  } catch (error) {
    next(error);
  }
});

// Update Profile
router.put('/profile', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    if (!token) {
      return res.status(401).json({
        error: 'Access token is required'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
    const user = await User.findById(decoded.userId);

    if (!user) {
      return res.status(404).json({
        error: 'User not found'
      });
    }

    const { name, email, avatar } = req.body;

    if (name) user.name = name;
    if (email) user.email = email;
    if (avatar) user.avatar = avatar;

    await user.save();

    res.json({
      message: 'Profile updated successfully',
      user: serializeUser(user)
    });
  } catch (error) {
    next(error);
  }
});

// Change Password
router.put('/password', async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    if (!token) {
      return res.status(401).json({
        error: 'Access token is required'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
    const user = await User.findById(decoded.userId).select('+password');

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
  } catch (error) {
    next(error);
  }
});

// Forgot Password
router.post('/forgot-password', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({
        error: 'User not found with this email'
      });
    }

    // Generate and store 6-digit verification code
    const verificationCode = String(Math.floor(100000 + Math.random() * 900000));
    const codeHash = crypto.createHash('sha256').update(verificationCode).digest('hex');
    user.passwordResetCodeHash = codeHash;
    user.passwordResetCodeExpiresAt = new Date(Date.now() + 10 * 60 * 1000);
    await user.save();

    // Send email
    await sendEmail({
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
  } catch (error) {
    next(error);
  }
});

// Verify reset code
router.post('/verify-reset-code', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, code } = req.body as { email?: string; code?: string };
    if (!email || !code) {
      return res.status(400).json({ error: 'Email and code are required' });
    }

    const user = await User.findOne({ email }).select('+passwordResetCodeHash');
    if (!user || !user.passwordResetCodeHash || !user.passwordResetCodeExpiresAt) {
      return res.status(400).json({ error: 'Invalid or expired verification code' });
    }
    if (user.passwordResetCodeExpiresAt.getTime() < Date.now()) {
      return res.status(400).json({ error: 'Invalid or expired verification code' });
    }

    const codeHash = crypto.createHash('sha256').update(String(code)).digest('hex');
    if (codeHash !== user.passwordResetCodeHash) {
      return res.status(400).json({ error: 'Invalid or expired verification code' });
    }

    const resetToken = jwt.sign(
      { userId: user._id, type: 'password_reset' },
      process.env.JWT_SECRET!,
      { expiresIn: '15m' }
    );

    res.json({ message: 'Code verified successfully', reset_token: resetToken });
  } catch (error) {
    next(error);
  }
});

// Reset Password
router.post('/reset-password', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { token, password } = req.body;

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
    if (decoded.type !== 'password_reset') {
      return res.status(400).json({
        error: 'Invalid reset token'
      });
    }

    const user = await User.findById(decoded.userId);
    if (!user) {
      return res.status(404).json({
        error: 'User not found'
      });
    }

    // Update password
    user.password = password;
    user.passwordResetCodeHash = null as any;
    user.passwordResetCodeExpiresAt = null as any;
    await user.save();

    res.json({
      message: 'Password reset successfully'
    });
  } catch (error) {
    next(error);
  }
});

// Logout
router.post('/logout', async (req: Request, res: Response) => {
  res.json({
    message: 'Logout successful'
  });
});

export default router;
