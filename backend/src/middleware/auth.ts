import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User, { IUser } from '../models/User';

interface AuthRequest extends Request {
  user?: IUser;
}

export const authMiddleware = async (req: AuthRequest, res: Response, next: NextFunction) => {
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
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      return res.status(401).json({
        error: 'Invalid token'
      });
    }
    if (error instanceof jwt.TokenExpiredError) {
      return res.status(401).json({
        error: 'Token expired'
      });
    }
    return res.status(401).json({
      error: 'Authentication failed'
    });
  }
};

export const premiumMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => {
  if (!req.user?.isPremium) {
    return res.status(403).json({
      error: 'Premium subscription required'
    });
  }
  next();
};

export const coupleMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => {
  if (!req.user?.coupleId || req.user.relationshipStatus !== 'connected') {
    return res.status(403).json({
      error: 'Must be connected to a partner to access this feature'
    });
  }
  next();
};
