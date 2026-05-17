# Google Login setup for Android Application

### Setup Google Cloud Console

* Go to [Google Cloud Console](https://console.cloud.google.com/?utm_source=chatgpt.com)
* Create / Select project
* Configure Consent Screen with `External` testers

---

### Create OAuth

* From sidebar, go to:

  * `API & Services`
  * `Credentials`
* Click on `Create Credentials`
* Select `OAuth Client ID`

#### Create one with `Application Type` Android

* From app environment, run:

```bash
keytool -keystore path-to-debug-or-production-keystore -list -v
```

* Copy the `SHA-1` key and paste it into Google Cloud Console
* Set the Android app package name
* Click `Create`

#### Create one with `Application Type` Web Application

* Again click `Create Credentials` → `OAuth Client ID`
* Select `Web Application`
* Add authorized redirect URIs if required by your backend/auth provider
* Click `Create`

> The `Web Client ID` is required for Android Google Sign-In configuration and backend token verification.

---

### Get Required Credentials

After creation, collect:

* Android OAuth Client ID
* Web OAuth Client ID
* SHA-1 fingerprint

---

### Android Configuration

Add the `Web Client ID` inside your Android app configuration.

Example:

```xml
<string name="default_web_client_id">
    YOUR_WEB_CLIENT_ID
</string>
```

Or in Kotlin:

```kotlin
val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
    .requestEmail()
    .requestIdToken(getString(R.string.default_web_client_id))
    .build()
```

---

### Backend Token Verification

Install:

```bash
npm install google-auth-library
```

Examples:

* [NestJS Example](./examples/nestjs.md)
* [Express Example](./examples/expressjs.md)

Both examples use the `Web Client ID` to verify Google login tokens.

---

### Notes

* Use separate SHA-1 keys for:

  * Debug keystore
  * Release keystore
* Google Login may fail if SHA-1 fingerprint is incorrect
* After updating credentials, it may take a few minutes for changes to propagate
