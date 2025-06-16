export default class ErrorHandler extends Error {
    constructor(public statusCode: number, public message: string) {
        super()
    }
}

export class BadRequest extends ErrorHandler {
    constructor(message: string) {
        super(400, message)
    }
}

export class Unauthorized extends ErrorHandler {
    constructor(message: string) {
        super(401, message)
    }
}

export class Forbidden extends ErrorHandler {
    constructor(message: string) {
        super(403, message)
    }
}
export class NotFound extends ErrorHandler {
    constructor(message: string) {
        super(404, message)
    }
}
export class InternalError extends ErrorHandler {
    constructor(message: string) {
        super(500, message)
    }
}
