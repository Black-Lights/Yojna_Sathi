# Firebase Configuration Script
# Run this after you've created your Firebase project

Write-Host "=== Firebase Setup for Yojna Sathi ===" -ForegroundColor Green
Write-Host ""

# Check if FlutterFire CLI is installed
Write-Host "Checking for FlutterFire CLI..." -ForegroundColor Yellow
$flutterfire = Get-Command flutterfire -ErrorAction SilentlyContinue

if (-not $flutterfire) {
    Write-Host "FlutterFire CLI not found. Installing..." -ForegroundColor Yellow
    dart pub global activate flutterfire_cli
    
    # Add Dart pub global bin to PATH for this session
    $dartPubCache = "$env:LOCALAPPDATA\Pub\Cache\bin"
    if (-not ($env:Path -like "*$dartPubCache*")) {
        $env:Path += ";$dartPubCache"
    }
    
    Write-Host "FlutterFire CLI installed successfully!" -ForegroundColor Green
} else {
    Write-Host "FlutterFire CLI already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Make sure you've created a Firebase project at https://console.firebase.google.com" -ForegroundColor White
Write-Host "2. Make sure you've downloaded google-services.json and placed it in android/app/" -ForegroundColor White
Write-Host "3. Run the following command to configure Firebase:" -ForegroundColor White
Write-Host ""
Write-Host "   flutterfire configure --project=your-project-id" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Or just run: flutterfire configure" -ForegroundColor Yellow
Write-Host "   (and select your project from the list)" -ForegroundColor White
Write-Host ""
Write-Host "4. This will update firebase_options.dart with your actual credentials" -ForegroundColor White
Write-Host ""

# Check if google-services.json exists
if (Test-Path "android\app\google-services.json") {
    Write-Host "✓ google-services.json found in android/app/" -ForegroundColor Green
} else {
    Write-Host "✗ google-services.json NOT found in android/app/" -ForegroundColor Red
    Write-Host "  Please download it from Firebase Console and place it there." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "After configuration, run:" -ForegroundColor Cyan
Write-Host "  flutter clean" -ForegroundColor Yellow
Write-Host "  flutter pub get" -ForegroundColor Yellow
Write-Host "  flutter run" -ForegroundColor Yellow
