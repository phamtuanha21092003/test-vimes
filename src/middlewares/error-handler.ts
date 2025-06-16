import { Request, Response, NextFunction } from "express"

import ErrorHandler from "@utils/errors"

export function errorHandlerMiddleware(error: ErrorHandler, req: Request, res: Response, next: NextFunction) {
    console.log(`error ${req.originalUrl}: \n`, error)

    if (error?.statusCode) {
        res.status(error.statusCode).json({ error: error.message })
    } else {
        res.status(500).json({ error: "Internal Server Error" })
    }
}
