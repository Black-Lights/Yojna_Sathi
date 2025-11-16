# Quick Start: Firebase Setup for Yojna Sathi

## Current Status
✅ App is running on emulator
✅ Authentication UI is working
✅ Android configuration is ready
❌ Firebase not configured (needs google-services.json and firebase_options.dart)

## 📋 Step-by-Step Setup (5-10 minutes)

### 1. Create Firebase Project
1. Open https://console.firebase.google.com in your browser
2. Click "Create a project" or "Add project"
3. Project name: **`yojna-sathi`** (or any name you prefer)
4. Click Continue
5. Disable Google Analytics (or enable if you want analytics)
6. Click "Create project" and wait ~30 seconds

### 2. Add Android App
1. In Firebase Console, click the **Android icon** (robot)
2. Fill in the form:
   - **Android package name**: `com.schemamitra.app` ⚠️ Must match exactly!
   - **App nickname**: Yojna Sathi (optional)
   - **Debug SHA-1**: Leave blank for now
3. Click "Register app"

### 3. Download google-services.json
1. Click "Download google-services.json"
2. Save the file
3. **Move it to**: `C:\Dev\Ali\Scheme_Website\android\app\google-services.json`
   
   The location is critical - it must be in the `android/app/` folder!

### 4. Enable Authentication
1. In Firebase Console, go to: **Build** → **Authentication**
2. Click "Get started"
3. Click on "Email/Password"
4. Toggle **Enable** to ON
5. Click "Save"

### 5. Create Firestore Database
1. In Firebase Console, go to: **Build** → **Firestore Database**
2. Click "Create database"
3. Choose "Start in **test mode**" (we'll secure it later)
4. Select location: **asia-south1** (Mumbai) for India users
5. Click "Enable"

### 6. Setup Firebase Storage
1. In Firebase Console, go to: **Build** → **Storage**
2. Click "Get started"
3. Choose "Start in **test mode**"
4. Same location as Firestore
5. Click "Done"

### 7. Configure Firebase in App
Open PowerShell in VS Code and run:

```powershell
# Install FlutterFire CLI (one-time setup)
dart pub global activate flutterfire_cli

# Login to Firebase (opens browser)
firebase login

# Configure the app (auto-updates firebase_options.dart)
flutterfire configure --project=your-project-id
```

Replace `your-project-id` with your actual Firebase project ID (found in Firebase Console → Project Settings)

Or just run:
```powershell
flutterfire configure
```
And select your project from the list.

### 8. Rebuild and Test
```powershell
flutter clean
flutter pub get
flutter run
```

## 🎯 Testing Authentication

Once configured, try these in the app:

### Sign Up
1. Click "Don't have an account? Sign up"
2. Enter:
   - Email: your.email@gmail.com
   - Password: test123456 (at least 6 characters)
3. Click "Sign Up"
4. Should create account and take you to profile creation

### Sign In
1. Enter the same credentials
2. Click "Sign In"
3. Should log you in

## 🔍 Troubleshooting

### "google-services.json not found"
- Make sure file is in: `android/app/google-services.json`
- Run `flutter clean` and try again

### "API key not valid"
- Run `flutterfire configure` to update firebase_options.dart
- Make sure you selected the correct Firebase project

### "No user record found"
- Make sure Email/Password auth is enabled in Firebase Console
- Try signing up first before signing in

### Build errors after adding google-services.json
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

## 📱 What Works After Setup

Once Firebase is configured, you'll have:

✅ **Email/Password Authentication**
- Sign up new users
- Sign in existing users
- Password reset (if implemented)

✅ **User Profiles in Firestore**
- Store user data (name, age, income, etc.)
- Retrieve user profiles
- Update profiles

✅ **Scheme Data**
- Browse government schemes
- Filter by eligibility
- Apply for schemes

✅ **Document Storage**
- Upload Aadhaar, PAN, etc.
- Store in Firebase Storage
- Retrieve for applications

## 🔐 Security (Do This Later)

After testing, update Firestore rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /schemes/{schemeId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins
    }
    match /applications/{applicationId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

## Need Help?

If you encounter any issues:
1. Check the Flutter console for error messages
2. Check Firebase Console → Authentication → Users (to see if users are being created)
3. Check Firebase Console → Firestore → Data (to see if data is being saved)
4. The app logs will show detailed error messages
