import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';

export const validateAuth = {
  register: async (req: Request, res: Response, next: NextFunction) => {
    const schema = Joi.object({
      name: Joi.string().required().min(2).max(50),
      email: Joi.string().email().required(),
      password: Joi.string().required().min(6),
    });

    try {
      await schema.validateAsync(req.body);
      return next();
    } catch (error) {
      return res.status(400).json({
        error: 'Validation failed',
        details: error
      });
    }
  },

  login: async (req: Request, res: Response, next: NextFunction) => {
    const schema = Joi.object({
      email: Joi.string().email().required(),
      password: Joi.string().required(),
    });

    try {
      await schema.validateAsync(req.body);
      return next();
    } catch (error) {
      return res.status(400).json({
        error: 'Validation failed',
        details: error
      });
    }
  }
};
