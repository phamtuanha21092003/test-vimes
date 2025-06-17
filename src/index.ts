import express, { Express } from "express"
import "dotenv/config"

import apiV1 from "@routers/v1"
import { config } from "@configs"

const port = process.env.PORT

const app: Express = express()

config(app)

app.use("/api/v1", apiV1)

app.listen(+port, () => {
    console.log(`Server is running on port ${port}`)
})
