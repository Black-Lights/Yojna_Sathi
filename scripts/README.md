# Firestore Data Seeding Scripts

This directory contains scripts for populating Firestore collections with initial data.

## Available Scripts

### 1. seed_schemes.dart

Seeds the `schemes` collection with initial government schemes data.

**What it does:**
- Adds 10 popular government schemes across various categories:
  - Agriculture (PM-KISAN, PM Fasal Bima Yojana)
  - Health (Ayushman Bharat)
  - Education (Post Matric Scholarship)
  - Housing (PMAY)
  - Business & Entrepreneurship (MUDRA, Stand Up India)
  - Women & Child Development (Sukanya Samriddhi, Beti Bachao Beti Padhao)
  - Senior Citizens (Atal Pension Yojana)

**Usage:**

Before running, make sure:
1. Firebase is configured in your project
2. You have admin access to your Firestore database
3. Your `firestore.rules` allow write access for seeding (temporarily if needed)

**Option 1: Run through Flutter app (Recommended)**

Create a temporary admin page in your app:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../scripts/seed_schemes.dart';

// In your admin page or debug screen
ElevatedButton(
  onPressed: () async {
    await seedSchemes(FirebaseFirestore.instance);
  },
  child: Text('Seed Schemes Data'),
)
```

**Option 2: Firebase CLI with Node.js**

Convert to JavaScript and run via Firebase Admin SDK (requires setup).

**Option 3: Manual Upload**

Use the Firebase Console to manually add schemes using the data structure from the script.

## Security Note

⚠️ **Important:** The seed scripts require write access to Firestore. For production:
1. Never expose seeding functionality to regular users
2. Run seeds only during initial setup or in development environment
3. Use Firebase Admin SDK from a secure backend for production seeding
4. Restore proper security rules after seeding

## Firestore Collections Structure

After seeding, your Firestore will have:

```
schemes/
├── pm-kisan-2024/
├── ayushman-bharat-2024/
├── sukanya-samriddhi-2024/
├── pmay-urban-2024/
├── pmmy-2024/
├── nsp-sc-2024/
├── pmfby-2024/
├── standup-india-2024/
├── apy-2024/
└── bbbp-2024/
```

## Adding More Schemes

To add more schemes:

1. Copy the scheme template from `seed_schemes.dart`
2. Update all fields with accurate information
3. Ensure `schemeId` is unique
4. Test the scheme structure matches your `Scheme` model
5. Run the seeding script

## Data Sources

Scheme information is sourced from:
- Official government websites
- Ministry portals
- National Portal of India (india.gov.in)
- Individual scheme websites

Always verify scheme details are current and accurate before deployment.

## Future Enhancements

- [ ] Add seed data for tutorials collection
- [ ] Create admin panel for scheme management
- [ ] Implement scheme data update scripts
- [ ] Add data validation before seeding
- [ ] Create backup/restore scripts

## Questions?

Refer to:
- Firebase Setup: `../FIREBASE_SETUP.md`
- Project Status: `../PROJECT_STATUS.md`
- Development Guide: `../DEVELOPMENT.md`
