# PowerShell script to seed schemes directly to Firestore
# This bypasses the emulator network issues by running from the host machine

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "   Firestore Scheme Seeding Script             " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is available
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Flutter not found. Please ensure Flutter is in your PATH." -ForegroundColor Red
    exit 1
}

Write-Host "Creating temporary Dart script..." -ForegroundColor Yellow

# Create a temporary Dart script that uses the SchemeDataset
$tempScript = @"
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schema_mitra/core/data/scheme_dataset.dart';
import 'package:schema_mitra/features/schemes/data/services/schemes_service.dart';
import 'package:schema_mitra/firebase_options.dart';

Future<void> main() async {
  print('\nInitializing Firebase...');
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('[OK] Firebase initialized successfully\n');
    
    final firestore = FirebaseFirestore.instance;
    final schemesService = SchemesService(firestore);
    
    print('Starting scheme seeding process...');
    print('----------------------------------------\n');
    
    await SchemeDataset.seedSchemes(schemesService);
    
    print('\n----------------------------------------');
    print('[OK] All schemes seeded successfully!');
    print('Check Firebase Console to verify\n');
    
    exit(0);
  } catch (e, stackTrace) {
    print('\n[ERROR] Error: `$e`');
    print('Stack trace: `$stackTrace`');
    exit(1);
  }
}
"@

$tempScriptPath = Join-Path $PSScriptRoot "temp_seed_runner.dart"
Set-Content -Path $tempScriptPath -Value $tempScript -Encoding UTF8

Write-Host "[OK] Temporary script created" -ForegroundColor Green
Write-Host ""
Write-Host "Running seeding script..." -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Yellow

# Navigate to project root and run the script
$projectRoot = Split-Path $PSScriptRoot -Parent
Set-Location $projectRoot

# Run the Dart script
flutter pub get | Out-Null
dart run $tempScriptPath

# Cleanup
Write-Host ""
Write-Host "Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item $tempScriptPath -Force -ErrorAction SilentlyContinue
Write-Host "Cleanup complete" -ForegroundColor Green
Write-Host ""
