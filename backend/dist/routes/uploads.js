"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const multer_1 = __importDefault(require("multer"));
const cloudinaryService_1 = require("../services/cloudinaryService");
const router = express_1.default.Router();
const upload = (0, multer_1.default)({
    storage: multer_1.default.memoryStorage(),
    limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
});
router.post('/image', upload.single('file'), async (req, res, next) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'file is required (multipart/form-data, field "file")' });
        }
        const folder = String(req.query.folder ?? 'duoday');
        const uploaded = await (0, cloudinaryService_1.uploadImageBuffer)({ buffer: req.file.buffer, folder });
        res.status(201).json({
            url: uploaded.secure_url,
            public_id: uploaded.public_id,
        });
    }
    catch (e) {
        next(e);
    }
});
exports.default = router;
