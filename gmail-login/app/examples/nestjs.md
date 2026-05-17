# Google Login Verification (NestJS)

Install:

```bash
npm install google-auth-library
```

## Example Service

```ts
import { Injectable } from "@nestjs/common";
import { OAuth2Client } from "google-auth-library";

@Injectable()
export class GoogleAuthService {
    private client: OAuth2Client;

    constructor() {
        this.client = new OAuth2Client(config.google.client_id);
    }

    async verify(payload: { idToken: string }) {
        const { idToken } = payload;

        let ticket;

        try {
            ticket = await this.client.verifyIdToken({
                idToken,
                audience: config.google.client_id,
            });
        } catch {
            throw new ApiError(
                HttpStatus.BAD_REQUEST,
                "Invalid Google id token",
            );
        }

        return ticket.getPayload();
    }
}
```

## Example Controller

```ts
import { Body, Controller, Post } from "@nestjs/common";

@Controller("auth")
export class AuthController {
    constructor(
        private readonly googleAuthService: GoogleAuthService,
    ) {}

    @Post("google")
    async login(@Body() body: { idToken: string }) {
        const payload = await this.googleAuthService.verify(body);

        return {
            success: true,
            payload,
        };
    }
}
```