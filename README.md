A simple app demonstrating how to import and use Ripple 2 components, in a standalone Vue 3 app.

### 1. Access to Github Packages repos

Ripple 2 is hosted publicly on Github Packages (ghcr), so a few steps need to be followed to co-exist with the npm ecosystem.

First, create a Personal Access Token from Github:

1. Visit https://github.com/settings/tokens and select **Generate new token** > **Generate new token (classic)**

<img width="240" src=".github/generate.jpg" alt="Screenshot of a clicked button (title Generate new token) that has opened a drop-down menu with two options: fine-grained and classic"><br>

2. Fill in the **Note** and choose an **Expiration** - the 30 day default is generally fine, you'll receive a reminder to regenerate the token just before expiry

<img width="400" src=".github/token.jpg" alt="Screenshot of personal access token setup form, with 'Note' filled in as 'public ghcr access' and 'Expiration' set to default of 30 days"><br>

3. Set the scope to only allow `read:packages`, and **Generate** token

<img width="600" src=".github/permissions.jpg" alt="Screenshot of scope, with only read:packages selected"><br>

4. Store the resulting token somewhere secure, and add to `.npmrc`:

```
@dpc-sdp:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=<github personal access token>
```

### 2. Local dev

1. `npm i`
2. `npm run dev`
