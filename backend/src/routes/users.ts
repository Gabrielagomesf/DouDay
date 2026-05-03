import express, { Response } from 'express';
import User from '../models/User';

const router = express.Router();

// Get user profile
router.get('/profile', async (req: any, res: Response) => {
  try {
    const uid = req.user?._id ?? req.user?.id;
    const user = await User.findById(uid);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      user: {
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
        createdAt: user.createdAt,
      }
    });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

export default router;
