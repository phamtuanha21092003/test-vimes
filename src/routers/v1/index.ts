import { Router, Request, Response } from "express"

import { errorHandlerMiddleware } from "@middlewares/error-handler"

const apiV1 = Router()

apiV1.use(errorHandlerMiddleware)

export default apiV1
