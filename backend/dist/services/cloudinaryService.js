"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadImageBuffer = uploadImageBuffer;
exports.deleteByPublicId = deleteByPublicId;
const cloudinary_1 = require("cloudinary");
cloudinary_1.v2.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
    secure: true,
});
async function uploadImageBuffer(params) {
    const { buffer, folder, publicId } = params;
    if (!process.env.CLOUDINARY_CLOUD_NAME || !process.env.CLOUDINARY_API_KEY || !process.env.CLOUDINARY_API_SECRET) {
        throw new Error('Cloudinary not configured');
    }
    return new Promise((resolve, reject) => {
        const stream = cloudinary_1.v2.uploader.upload_stream({
            folder,
            public_id: publicId,
            overwrite: true,
            resource_type: 'image',
        }, (error, result) => {
            if (error || !result)
                return reject(error ?? new Error('Cloudinary upload failed'));
            resolve({ secure_url: result.secure_url, public_id: result.public_id });
        });
        stream.end(buffer);
    });
}
async function deleteByPublicId(publicId) {
    if (!publicId)
        throw new Error('publicId is required');
    return cloudinary_1.v2.uploader.destroy(publicId, { invalidate: true, resource_type: 'image' });
}
