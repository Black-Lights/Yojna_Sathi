# Fix Android Emulator Network Connectivity

The schemes aren't uploading because your Android emulator can't reach `firestore.googleapis.com`. Here are solutions:

## Quick Fix Options

### Option 1: Cold Boot the Emulator (Recommended)
1. Close the running emulator
2. Open **Android Studio** → **Device Manager** (or **AVD Manager**)
3. Click the **dropdown arrow** next to your emulator
4. Select **Cold Boot Now**
5. Wait for emulator to fully restart
6. Run `flutter run` again
7. Navigate to **Settings** → Tap **"Seed Comprehensive Schemes"**

### Option 2: Check Emulator Network Settings
1. While emulator is running, open **Settings** app in emulator
2. Go to **Network & Internet** → **Internet**
3. Make sure WiFi is connected (AndroidWifihas internet)
4. If not, toggle WiFi off and on

### Option 3: Restart ADB
```powershell
# Kill and restart ADB
flutter doctor -v
adb kill-server
adb start-server
flutter run
```

### Option 4: Use a Physical Android Device
1. Enable **Developer Options** on your phone
2. Enable **USB Debugging**
3. Connect phone via USB
4. Run: `flutter devices` (should show your phone)
5. Run: `flutter run` (will install on phone)
6. Phone will have internet access natively

### Option 5: Update Emulator System Image
1. **Android Studio** → **Tools** → **SDK Manager**
2. **SDK Platforms** tab → Check your Android version (e.g., Android 14)
3. **SDK Tools** tab → Update **Android Emulator** and **Google Play Services**
4. Restart emulator

## Verify Network Connectivity

After applying a fix, verify in emulator:
1. Open **Chrome** browser in emulator
2. Try visiting `https://google.com`
3. If Chrome works, Firestore will work too

## Alternative: Manual Data Upload

If emulator issues persist, I can provide a Node.js script to upload schemes directly using Firebase Admin SDK from your PC.

## What Happened?

The app tried to seed 41 schemes but got:
```
Unable to resolve host firestore.googleapis.com: No address associated with hostname
```

This is a DNS resolution issue in the emulator's network stack, not a code problem.
