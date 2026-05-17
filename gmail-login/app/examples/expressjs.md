# Google Login Verification (Express)

Install:

```bash
npm install express google-auth-library
```

## Example

```ts
import express from "express";
import { OAuth2Client } from "google-auth-library";

const app = express();

app.use(express.json());

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

app.post("/auth/google", async (req, res) => {
    const { idToken } = req.body;

    try {
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID,
        });

        const payload = ticket.getPayload();

        return res.json({
            success: true,
            payload,
        });
    } catch {
        return res.status(400).json({
            success: false,
            message: "Invalid Google id token",
        });
    }
});

app.listen(3000);
```
