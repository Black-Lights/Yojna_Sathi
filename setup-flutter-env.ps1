# Flutter Environment Setup Script
# Run this script in PowerShell to reload PATH and set up Flutter environment

Write-Host "=== Flutter Environment Setup ===" -ForegroundColor Green
Write-Host ""

# Set JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
Write-Host "✓ JAVA_HOME set to Android Studio JDK" -ForegroundColor Green

# Reload PATH
$env:Path = "$env:JAVA_HOME\bin;" + [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")
Write-Host "✓ PATH reloaded" -ForegroundColor Green

# Verify Flutter
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "✓ Flutter is available" -ForegroundColor Green
    flutter --version
} else {
    Write-Host "✗ Flutter not found in PATH" -ForegroundColor Red
}

Write-Host ""
Write-Host "Quick Commands:" -ForegroundColor Yellow
Write-Host "  flutter doctor       - Check Flutter installation"
Write-Host "  flutter doctor -v    - Detailed check"
Write-Host "  flutter pub get      - Install dependencies"
Write-Host "  flutter run          - Run the app"
Write-Host ""
