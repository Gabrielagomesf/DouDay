import express, { NextFunction, Request, Response } from 'express';
import multer from 'multer';
import { uploadImageBuffer } from '../services/cloudinaryService';

const router = express.Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB
});

router.post('/image', upload.single('file'), async (req: Request, res: Response, next: NextFunction) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'file is required (multipart/form-data, field "file")' });
    }

    const folder = String(req.query.folder ?? 'duoday');
    const uploaded = await uploadImageBuffer({ buffer: req.file.buffer, folder });

    res.status(201).json({
      url: uploaded.secure_url,
      public_id: uploaded.public_id,
    });
  } catch (e) {
    next(e);
  }
});

export default router;

