import mongoose from 'mongoose';
import { Response } from 'express';

/** Campos que nunca podem vir do cliente em PUT/PATCH. */
const FORBIDDEN_BODY_KEYS = new Set([
  '_id',
  'id',
  'coupleId',
  'createdBy',
  '__v',
  'createdAt',
  'updatedAt',
]);

export function sanitizeClientBody(body: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};
  if (!body || typeof body !== 'object') return out;
  for (const [k, v] of Object.entries(body)) {
    if (!FORBIDDEN_BODY_KEYS.has(k)) out[k] = v;
  }
  return out;
}

export function isValidMongoId(id: string | undefined): boolean {
  if (!id || typeof id !== 'string') return false;
  return mongoose.Types.ObjectId.isValid(id);
}

/** Responde 400 se o parâmetro :id não for ObjectId válido. */
export function requireMongoIdParam(id: string | undefined, res: Response): boolean {
  if (!isValidMongoId(id)) {
    res.status(400).json({ error: 'Invalid id' });
    return false;
  }
  return true;
}
