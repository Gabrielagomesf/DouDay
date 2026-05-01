"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const User_1 = __importDefault(require("../models/User"));
const Couple_1 = __importDefault(require("../models/Couple"));
const auth_1 = require("../middleware/auth");
const router = express_1.default.Router();
// Generate invite code
router.post('/invite', auth_1.authMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        // Check if user already has a couple
        if (user.coupleId) {
            return res.status(400).json({
                error: 'User is already in a couple'
            });
        }
        // Generate unique invite code
        let inviteCode;
        let existingCouple;
        do {
            inviteCode = user.generateInviteCode();
            existingCouple = await Couple_1.default.findOne({ inviteCode });
        } while (existingCouple);
        // Create new couple with pending status
        const couple = new Couple_1.default({
            user1Id: user._id,
            user1Name: user.name,
            status: 'pending',
            inviteCode
        });
        await couple.save();
        // Update user
        user.coupleId = couple._id;
        user.relationshipStatus = 'pending';
        user.inviteCode = inviteCode;
        await user.save();
        res.json({
            message: 'Invite code generated successfully',
            couple: {
                id: couple._id,
                inviteCode: couple.inviteCode,
                status: couple.status,
                user1Name: couple.user1Name,
                createdAt: couple.createdAt
            }
        });
    }
    catch (error) {
        next(error);
    }
});
// Connect with partner using invite code
router.post('/connect', auth_1.authMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const { inviteCode } = req.body;
        if (!inviteCode) {
            return res.status(400).json({
                error: 'Invite code is required'
            });
        }
        // Check if user is already in a couple
        if (user.coupleId) {
            return res.status(400).json({
                error: 'User is already in a couple'
            });
        }
        // Find couple with invite code
        const couple = await Couple_1.default.findOne({
            inviteCode,
            status: 'pending'
        }).populate('user1Id', 'name email avatar');
        if (!couple) {
            return res.status(404).json({
                error: 'Invalid or expired invite code'
            });
        }
        // Check if user is trying to connect with themselves
        if (couple.user1Id._id.toString() === user._id.toString()) {
            return res.status(400).json({
                error: 'Cannot connect with yourself'
            });
        }
        // Update couple with second user
        couple.user2Id = user._id;
        couple.user2Name = user.name;
        couple.status = 'connected';
        couple.connectedAt = new Date();
        await couple.save();
        // Update both users
        await User_1.default.findByIdAndUpdate(couple.user1Id._id, {
            relationshipStatus: 'connected',
            partnerId: user._id,
            partnerName: user.name,
            inviteCode: null
        });
        user.relationshipStatus = 'connected';
        user.partnerId = couple.user1Id._id;
        user.partnerName = couple.user1Name;
        user.coupleId = couple._id;
        await user.save();
        // Get updated couple with both users
        const updatedCouple = await Couple_1.default.findById(couple._id)
            .populate('user1Id', 'name email avatar')
            .populate('user2Id', 'name email avatar');
        res.json({
            message: 'Connected successfully with your partner',
            couple: updatedCouple
        });
    }
    catch (error) {
        next(error);
    }
});
// Get couple information
router.get('/info', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const couple = await Couple_1.default.findById(user.coupleId)
            .populate('user1Id', 'name email avatar')
            .populate('user2Id', 'name email avatar');
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        res.json({
            couple: {
                id: couple._id,
                user1Id: couple.user1Id,
                user2Id: couple.user2Id,
                user1Name: couple.user1Name,
                user2Name: couple.user2Name,
                status: couple.status,
                connectedAt: couple.connectedAt,
                anniversary: couple.anniversary,
                relationshipGoal: couple.relationshipGoal,
                sharedNotes: couple.sharedNotes,
                createdAt: couple.createdAt,
                updatedAt: couple.updatedAt
            }
        });
    }
    catch (error) {
        next(error);
    }
});
// Update couple information
router.put('/info', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const { anniversary, relationshipGoal } = req.body;
        const couple = await Couple_1.default.findById(user.coupleId);
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        if (anniversary)
            couple.anniversary = new Date(anniversary);
        if (relationshipGoal)
            couple.relationshipGoal = relationshipGoal;
        await couple.save();
        res.json({
            message: 'Couple information updated successfully',
            couple: {
                id: couple._id,
                anniversary: couple.anniversary,
                relationshipGoal: couple.relationshipGoal
            }
        });
    }
    catch (error) {
        next(error);
    }
});
// Add shared note
router.post('/notes', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const { content } = req.body;
        if (!content) {
            return res.status(400).json({
                error: 'Note content is required'
            });
        }
        const couple = await Couple_1.default.findById(user.coupleId);
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        await couple.addSharedNote(content, user._id);
        const updatedCouple = await Couple_1.default.findById(user.coupleId);
        res.json({
            message: 'Note added successfully',
            notes: updatedCouple?.sharedNotes
        });
    }
    catch (error) {
        next(error);
    }
});
// Get shared notes
router.get('/notes', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const couple = await Couple_1.default.findById(user.coupleId);
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        res.json({
            notes: couple.sharedNotes || []
        });
    }
    catch (error) {
        next(error);
    }
});
// Delete shared note
router.delete('/notes/:noteId', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const { noteId } = req.params;
        const couple = await Couple_1.default.findById(user.coupleId);
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        // Find and remove note
        const noteIndex = couple.sharedNotes?.findIndex((note) => note._id.toString() === noteId);
        if (noteIndex === -1 || noteIndex === undefined) {
            return res.status(404).json({
                error: 'Note not found'
            });
        }
        // Check if user is the author of the note
        const note = couple.sharedNotes[noteIndex];
        if (note.authorId.toString() !== user._id.toString()) {
            return res.status(403).json({
                error: 'You can only delete your own notes'
            });
        }
        couple.sharedNotes?.splice(noteIndex, 1);
        await couple.save();
        res.json({
            message: 'Note deleted successfully'
        });
    }
    catch (error) {
        next(error);
    }
});
// Disconnect from partner
router.post('/disconnect', auth_1.authMiddleware, auth_1.coupleMiddleware, async (req, res, next) => {
    try {
        const user = req.user;
        const couple = await Couple_1.default.findById(user.coupleId);
        if (!couple) {
            return res.status(404).json({
                error: 'Couple not found'
            });
        }
        // Update couple status
        couple.status = 'disconnected';
        await couple.save();
        // Update both users
        await User_1.default.findByIdAndUpdate(couple.user1Id, {
            relationshipStatus: 'single',
            partnerId: null,
            partnerName: null,
            coupleId: null,
            inviteCode: null
        });
        if (couple.user2Id) {
            await User_1.default.findByIdAndUpdate(couple.user2Id, {
                relationshipStatus: 'single',
                partnerId: null,
                partnerName: null,
                coupleId: null,
                inviteCode: null
            });
        }
        res.json({
            message: 'Disconnected successfully'
        });
    }
    catch (error) {
        next(error);
    }
});
exports.default = router;
