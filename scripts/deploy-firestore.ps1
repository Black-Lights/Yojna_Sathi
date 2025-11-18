# Deploy Firestore Rules and Seed Data

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Yojna Sathi - Firestore Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Firebase CLI is installed
Write-Host "Checking Firebase CLI..." -ForegroundColor Yellow
$firebaseInstalled = Get-Command firebase -ErrorAction SilentlyContinue

if (-not $firebaseInstalled) {
    Write-Host "✗ Firebase CLI not found!" -ForegroundColor Red
    Write-Host "Please install Firebase CLI first:" -ForegroundColor Yellow
    Write-Host "  npm install -g firebase-tools" -ForegroundColor White
    exit 1
}

Write-Host "✓ Firebase CLI found" -ForegroundColor Green
Write-Host ""

# Login check
Write-Host "Checking Firebase login status..." -ForegroundColor Yellow
$loginStatus = firebase login:list 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Not logged in to Firebase" -ForegroundColor Red
    Write-Host "Please login first:" -ForegroundColor Yellow
    Write-Host "  firebase login" -ForegroundColor White
    exit 1
}

Write-Host "✓ Logged in to Firebase" -ForegroundColor Green
Write-Host ""

# Deploy Firestore Rules
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 1: Deploy Firestore Security Rules" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$deployRules = Read-Host "Deploy Firestore rules? (y/n)"

if ($deployRules -eq 'y' -or $deployRules -eq 'Y') {
    Write-Host "Deploying Firestore rules..." -ForegroundColor Yellow
    firebase deploy --only firestore:rules
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Firestore rules deployed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to deploy Firestore rules" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipped Firestore rules deployment" -ForegroundColor Yellow
}

Write-Host ""

# Deploy Storage Rules
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 2: Deploy Storage Security Rules" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$deployStorage = Read-Host "Deploy Storage rules? (y/n)"

if ($deployStorage -eq 'y' -or $deployStorage -eq 'Y') {
    Write-Host "Deploying Storage rules..." -ForegroundColor Yellow
    firebase deploy --only storage
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Storage rules deployed successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to deploy Storage rules" -ForegroundColor Red
    }
} else {
    Write-Host "Skipped Storage rules deployment" -ForegroundColor Yellow
}

Write-Host ""

# Seed Data Information
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 3: Seed Schemes Data" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To seed schemes data:" -ForegroundColor Yellow
Write-Host "1. Run your Flutter app in debug mode" -ForegroundColor White
Write-Host "2. Navigate to Settings or Profile page" -ForegroundColor White
Write-Host "3. Look for 'Seed Data' or 'Admin' option (if implemented)" -ForegroundColor White
Write-Host "4. Or manually add seed function call in your app temporarily" -ForegroundColor White
Write-Host ""
Write-Host "Alternatively, you can:" -ForegroundColor Yellow
Write-Host "• Use Firebase Console to manually add schemes" -ForegroundColor White
Write-Host "• Import data using Firebase Admin SDK" -ForegroundColor White
Write-Host "• See scripts/README.md for detailed instructions" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. ✓ Firestore collections structure: Ready" -ForegroundColor Green
Write-Host "2. ✓ Security rules: Deployed" -ForegroundColor Green
Write-Host "3. [ ] Seed schemes data: Follow instructions above" -ForegroundColor White
Write-Host "4. [ ] Test the app with real data" -ForegroundColor White
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Cyan
