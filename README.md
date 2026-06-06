# SmartCook AI — Web App

SmartCook AI is a Flutter web application that plans meals around your day, budget, dietary preferences, and available ingredients. The web build is configured for Firebase Hosting and is ready to deploy from the `build/web` folder.

## Features
- Input-driven meal planning: busy level, budget, people count, diet preference, and pantry ingredients
- Daily summary and estimated cooking time
- Interactive timeline and plan score
- Editable grocery list with estimated costs and savings
- Substitution toggles that re-evaluate the plan
- Responsive layout with dark/light themes

## Local development (run in browser)
1. Ensure Flutter is installed and web support is enabled:

```bash
flutter --version
flutter config --list  # confirm enable-web: true
```

2. Run the app on the web-server (open the provided URL in a browser):

```bash
flutter run -d web-server --web-port 8080 --web-hostname 127.0.0.1
```

Or run on Chrome if available:

```bash
flutter run -d chrome
```

## Build for production

```bash
flutter build web --release
```

This writes optimized static assets to `build/web`.

## Deploy to Firebase Hosting
1. Create a Firebase project in the Firebase console (or use an existing one).
2. Install the Firebase CLI (if not installed):

```bash
npm install -g firebase-tools
```

3. Log in and select the project (the repository includes `.firebaserc` with the project id `smart-ai-cook`):

```bash
firebase login
firebase use --add
```

4. Build and deploy:

```bash
flutter build web --release
firebase deploy --only hosting
```

After deploy the site will be available at `https://<your-project-id>.web.app` (for example `https://smart-ai-cook.web.app`).

## Files added for Hosting
- `firebase.json` — hosting configuration (serves `build/web` and rewrites to `index.html`)
- `.firebaserc` — project binding (default: `smart-ai-cook`)

## Troubleshooting
- If you see the Firebase default page after deploy, ensure `firebase.json` has `public: "build/web"` and that you deployed after running `flutter build web --release`.
- Try an incognito window or clear cache if you get cached content.

---
If you'd like, I can update this further with screenshots, a demo link, or CI instructions for automatic deploys.
