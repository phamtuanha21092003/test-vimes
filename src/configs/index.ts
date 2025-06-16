import express, { Express, Request, Response } from "express"
import morgan from "morgan"
import path from "path"
import cors from "cors"

export function config(app: Express) {
    app.use(morgan("dev"))

    app.use(cors())

    app.set("view engine", "hbs")

    app.set("views", path.join(process.cwd(), "src/views")) // TODO: could change path id run in production

    app.use(express.json({ type: "*/json" }))

    app.use(express.urlencoded({ extended: true, limit: "10mb" }))

    app.get("/ping", (req, res) => {
        res.json({ ping: "pong" })
    })
}
