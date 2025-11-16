# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add Project" or select an existing project
3. Enter project name: `Yojna Sathi` or `SchemaMitra`
4. Accept terms and click Continue
5. Disable Google Analytics (optional) or configure it
6. Click "Create Project"

## Step 2: Add Android App to Firebase

1. In Firebase Console, click the Android icon to add an Android app
2. Enter the following details:
   - **Android package name**: `com.schemamitra.app` (must match the package in AndroidManifest.xml)
   - **App nickname (optional)**: Yojna Sathi Android
   - **Debug signing certificate SHA-1 (optional)**: Leave blank for now
3. Click "Register app"

## Step 3: Download google-services.json

1. Download the `google-services.json` file
2. Place it in: `android/app/google-services.json`
3. DO NOT commit this file to Git (it's already in .gitignore)

## Step 4: Enable Authentication

1. In Firebase Console, go to "Build" > "Authentication"
2. Click "Get Started"
3. Enable the following sign-in methods:
   - **Email/Password** - Click Enable and Save
   - **Phone** (optional) - For OTP-based login

## Step 5: Configure Firestore Database

1. In Firebase Console, go to "Build" > "Firestore Database"
2. Click "Create database"
3. Start in **test mode** (we'll update rules later)
4. Select a location close to your users (e.g., asia-south1 for India)
5. Click "Enable"

## Step 6: Configure Firebase Storage

1. In Firebase Console, go to "Build" > "Storage"
2. Click "Get started"
3. Start in **test mode**
4. Click "Done"

## Step 7: Generate Firebase Configuration

Run the FlutterFire CLI to automatically generate the configuration:

```powershell
# Install FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Login to Firebase (will open browser)
flutterfire configure

# Select your Firebase project
# Select platforms: Android, iOS, Web
# This will automatically update firebase_options.dart
```

## Step 8: Verify Setup

After placing google-services.json and running flutterfire configure:

```powershell
flutter clean
flutter pub get
flutter run
```

## Troubleshooting

### If you get "google-services.json not found":
- Ensure the file is in `android/app/google-services.json`
- Check that android/build.gradle has: `classpath 'com.google.gms:google-services:4.3.15'`
- Check that android/app/build.gradle has: `apply plugin: 'com.google.gms.google-services'`

### If you get Firebase initialization errors:
- Run `flutterfire configure` again
- Make sure package name matches in AndroidManifest.xml and Firebase Console
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`

## Next Steps

Once Firebase is configured, the app will have:
- ✅ Email/Password Authentication
- ✅ Phone OTP Authentication (if enabled)
- ✅ User Profile Storage in Firestore
- ✅ Document Upload to Firebase Storage
- ✅ Real-time scheme updates
- ✅ Push notifications via FCM
