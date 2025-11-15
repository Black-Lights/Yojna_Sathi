# SchemaMitra Setup Guide

This guide will help you set up and run the SchemaMitra Flutter application.

## Step 1: Install Flutter

1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Extract the SDK and add to your PATH
3. Run `flutter doctor` to verify installation

## Step 2: Install Dependencies

```bash
cd Scheme_Website
flutter pub get
```

## Step 3: Firebase Setup

### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "SchemaMitra"
4. Follow the setup wizard

### 3.2 Add Android App

1. In Firebase Console, click "Add app" → Android
2. Package name: `com.example.schema_mitra`
3. Download `google-services.json`
4. Place in `android/app/` directory

### 3.3 Add iOS App

1. Click "Add app" → iOS
2. Bundle ID: `com.example.schemaMitra`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/` directory

### 3.4 Update Firebase Configuration

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```

3. This will update `lib/firebase_options.dart` automatically

### 3.5 Enable Authentication

1. In Firebase Console → Authentication → Sign-in method
2. Enable:
   - Email/Password
   - Phone
   - Google (optional)

### 3.6 Create Firestore Database

1. In Firebase Console → Firestore Database
2. Click "Create database"
3. Start in test mode (we'll deploy rules later)
4. Choose a location close to your users

### 3.7 Enable Cloud Storage

1. In Firebase Console → Storage
2. Click "Get started"
3. Start in test mode

### 3.8 Deploy Security Rules

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
firebase init

# Select:
# - Firestore
# - Storage
# - Use existing project: SchemaMitra

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
```

### 3.9 Enable Cloud Messaging (FCM)

1. In Firebase Console → Cloud Messaging
2. Note down your Server Key (for backend notifications)

## Step 4: Add Assets

### 4.1 Create Asset Folders

```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p assets/logos
mkdir -p assets/fonts
```

### 4.2 Add Fonts

Download Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins) and place in `assets/fonts/`:
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-SemiBold.ttf
- Poppins-Bold.ttf

### 4.3 Add App Logo

Create or download an app logo and place in `assets/logos/logo.png`

## Step 5: Populate Initial Data

### 5.1 Add Sample Schemes

Create a script or use Firebase Console to add initial schemes to the `schemes` collection. Example scheme:

```json
{
  "schemeId": "pmkisan",
  "name": "Pradhan Mantri Kisan Samman Nidhi",
  "ministry": "Ministry of Agriculture",
  "category": "Agriculture",
  "description": "Direct income support to farmers",
  "eligibility": {
    "minAge": 18,
    "maxAge": null,
    "incomeMax": null,
    "categories": ["General", "SC", "ST", "OBC"],
    "occupations": ["Farmer"],
    "states": ["All"],
    "education": ["All"]
  },
  "benefits": {
    "amount": 6000,
    "type": "cash_transfer",
    "frequency": "annual",
    "description": "₹6000 per annum in 3 installments"
  },
  "applicationProcess": "Online via eKYC or CSC",
  "documentsRequired": ["Aadhaar", "Land Records"],
  "officialLink": "https://pmkisan.gov.in",
  "launchDate": "2018-12-01T00:00:00Z",
  "source": "central"
}
```

## Step 6: Configure Android

### 6.1 Update build.gradle

In `android/app/build.gradle`, ensure:

```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "com.example.schema_mitra"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
        multiDexEnabled true
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-analytics'
    implementation platform('com.google.firebase:firebase-bom:32.0.0')
}
```

### 6.2 Update AndroidManifest.xml

The file has been created with necessary permissions.

## Step 7: Configure iOS

### 7.1 Update Info.plist

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to upload documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires photo library access to upload documents</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location access to show nearby schemes</string>
```

## Step 8: Run the App

### Development Mode

```bash
# Check for issues
flutter doctor

# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

### Hot Reload

While the app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

## Step 9: Testing

### Run Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## Step 10: Build for Production

### Android

```bash
# Generate release APK
flutter build apk --release

# Generate app bundle (recommended for Play Store)
flutter build appbundle --release

# Output location:
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace
```

## Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `google-services.json` is in `android/app/`
   - Run `flutterfire configure`

2. **Dependency conflicts**
   ```bash
   flutter pub cache repair
   flutter clean
   flutter pub get
   ```

3. **Build failures**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

4. **iOS build issues**
   ```bash
   cd ios
   pod deintegrate
   pod install
   cd ..
   flutter clean
   ```

### Getting Help

- Check [Flutter Documentation](https://flutter.dev/docs)
- Visit [Firebase Documentation](https://firebase.google.com/docs)
- Join [Flutter Community](https://flutter.dev/community)

## Next Steps

1. Customize the app theme in `lib/config/theme/app_theme.dart`
2. Add more schemes to Firestore
3. Create tutorial videos and upload to Cloud Storage
4. Set up Cloud Functions for advanced features
5. Implement analytics tracking
6. Add localization files for Hindi and other languages

## Production Checklist

- [ ] Update app name and package name
- [ ] Add app icon (use flutter_launcher_icons package)
- [ ] Update Firebase security rules for production
- [ ] Set up error tracking (e.g., Sentry, Crashlytics)
- [ ] Implement analytics
- [ ] Test on multiple devices
- [ ] Optimize images and assets
- [ ] Enable ProGuard/R8 for Android
- [ ] Create privacy policy and terms of service
- [ ] Submit to Google Play Store / Apple App Store

---

**Happy Coding!** 🚀
