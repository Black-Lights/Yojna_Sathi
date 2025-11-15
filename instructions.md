# SchemaMitra: Government Scheme Eligibility & Application Flutter App

## Project Overview
SchemaMitra is a mobile-first application built with Flutter and Firebase that enables citizens to discover, match, and apply for central and state government schemes in India. The app features personalized profile creation, automatic eligibility matching, direct application options, offline browsing, new scheme notifications, and tutorial guides. The instructions below are structured for collaborative development within VS Code and GitHub Copilot.

---

## Tech Stack
- **Frontend:** Flutter (Dart), Material Design UI
- **State Management:** BLoC pattern
- **Backend (Recommended):** Firebase (Firestore, Authentication, Cloud Functions, Cloud Storage, FCM)
- **Alternate Backend:** Django REST API or Node.js for advanced integrations
- **Offline Database:** Hive/SQLite (optional)
- **DevOps:** GitHub Actions (CI/CD), Firebase Hosting (admin panel)

---

## Firestore Database Schema

### users
```json
{
  "userId": "user123",
  "profile": {
    "name": "John Doe",
    "age": 35,
    "gender": "M",
    "email": "john@example.com",
    "phone": "+919876543210",
    "income": "2-5L",
    "occupation": "Farmer",
    "category": "SC",
    "education": "10th Pass",
    "specialConditions": ["disability"],
    "location": {
      "state": "Bihar",
      "district": "Patna",
      "village": "Sample Village",
      "latitude": 25.59,
      "longitude": 85.12
    }
  },
  "createdAt": "2025-11-14T...",
  "lastUpdated": "2025-11-14T..."
}
```

### schemes
```json
{
  "schemeId": "scheme123",
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
  "launchDate": "2018-12-01",
  "deadline": null,
  "source": "central",
  "videoTutorialId": "tutorial123"
}
```

### user_schemes (matched/applied)
```json
{
  "recordId": "user123_scheme123",
  "userId": "user123",
  "schemeId": "scheme123",
  "status": "eligible",
  "matchScore": 0.95,
  "appliedAt": "2025-11-14T...",
  "applicationRef": "PMK-2025-1234567",
  "documents": [{ "documentId": "doc123", "type": "Aadhaar", "uploadedAt": "2025-11-14T...", "storagePath": "gs://bucket/documents/doc123" }],
  "lastUpdated": "2025-11-14T..."
}
```

### scheme_launches
```json
{
  "launchId": "launch123",
  "schemeId": "scheme_new",
  "launchDate": "2025-11-14T...",
  "source": "PIB",
  "notificationsSent": 1250
}
```

### tutorials
```json
{
  "tutorialId": "tut123",
  "schemeId": "scheme123",
  "title": "How to Apply for PM-KISAN",
  "language": "Hindi",
  "videoUrl": "gs://bucket/videos/tut123.mp4",
  "duration": 180,
  "steps": [{ "stepNumber": 1, "title": "Check Eligibility", "description": "Verify you are a registered farmer", "imageUrl": "gs://bucket/images/step1.jpg" }]
}
```

---

## App Features & User Stories

### User
- Register and log in (Google/Phone/Email)
- Create and update user profile with essential info
- Browse government schemes, filter by eligibility
- See which schemes you are eligible for with explanations
- Apply for schemes (API or redirect)
- Upload required documents
- Track status of applications
- Receive notifications for new schemes
- View tutorials on scheme application steps
- Multi-language UI (Hindi, English, selected states)
- Offline access to scheme database and tutorials

### Admin
- Add and update scheme details
- Monitor new scheme launches (auto from PIB/web scraping, manual input)
- Review user applications and application logs
- Push notifications to users on new launches
- Access analytics dashboard for app metrics

---

## API Integration
- **Scheme Data:** Connect to `myScheme API` via API Setu
- **State Schemes:** Integrate with selected state portals as available
- **New Scheme Detection:** Scrape or monitor PIB.gov.in, add to launch collection
- **Application Submission:** Direct submission for API-enabled, PDF/download for others
- **Authentication:** Aadhaar eKYC API (optional phase 2)

---

## Cloud Functions & Backend Logic (Pseudocode)

**Eligibility Matching Function (Python/Node.js):**
```python
# params: user_profile, scheme
# returns: eligibility_status, reason, match_score
if user_profile['age'] < scheme['eligibility']['minAge']:
    status = 'not eligible'
    reason = 'Below minimum age requirement'
    score = 0.0
elif user_profile['category'] in scheme['eligibility']['categories']:
    status = 'eligible'
    reason = 'Category matched'
    score = 1.0
else:
    status = 'may be eligible'
    reason = 'Partial match, manual review recommended'
    score = 0.5
return status, reason, score
```

---

## Flutter Architecture
- Use BLoC pattern for state management (schemes, user auth, applications)
- Maintain local cache of schemes and tutorials for offline use
- UI pages:
  - Splash/Login/Register
  - Profile Creation (with input validation)
  - Home/Dashboard (show eligible, available, applied schemes)
  - Scheme Details (with eligibility match, apply button)
  - Application Flow (upload docs, track status)
  - Tutorial Player
  - Notifications Center
  - Settings (language, notification preferences)

---

## Data Sources and References
- **Central Schemes:** Kaggle dataset, data.gov.in API, myScheme.gov.in API (via API Setu)
- **State Schemes:** Individual state portals, API Setu as available
- **New Schemes:** PIB press releases (scraping), official ministry websites
- **Tutorials:** Firebase Cloud Storage videos/images, translated by language

---

## Testing and QA
- Write automated tests for application flows and backend logic
- QA offline/online transitions for data sync
- Validate eligibility logic with 10+ real world test profiles
- Test push notifications on multiple devices/OS

---

## Security Measures
- Enforce Firebase Auth for all actions
- Use Firestore security rules to restrict data
- Encrypt sensitive personal info where required
- Use HTTPS/TLS for all API calls

---

## Continuous Integration & Delivery
- Use GitHub Actions for build/test/deploy (Flutter app, Cloud Functions)
- Store codebase in GitHub repo (main branch for production)
- Configure staging and production environments

---

## Naming & Branding
- **App Name:** SchemaMitra
- **Tagline:** Aapka Haq, Aapke Haath Mein
- **Logo:** Outline of helping hands with government building icon

---

## Future Improvements
- Integrate Aadhaar and offline CSC verification
- Video tutorials for every scheme, multi-language expansion
- AI-based recommendation engine for personalized scheme discovery
- GIS/map integration for location-based benefits

---

## Contribution Guide
- Use GitHub Issues/PRs for all changes
- Ensure all documentation updates are reflected in instructions.md
- Tag all features implemented for traceability

---

> **This instructions.md serves as the single source of truth for SchemaMitra Flutter app development. Update regularly with architecture, data structure, feature, and roadmap changes.**
