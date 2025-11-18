# Yojna Sathi - Project Status & Roadmap

**Developers:**
- Ali Rehman - [@Alirehman7062](https://github.com/Alirehman7062)
- Black Lights - [@Black-Lights](https://github.com/Black-Lights)

**Last Updated:** November 18, 2025 (Evening - Notifications Module Complete & Ready for Merge)

---

## 📋 Project Overview

**Project Name:** Yojna Sathi  
**Description:** Government Scheme Eligibility & Application Mobile App  
**Platform:** Flutter (Android & iOS)  
**Current Version:** 1.0.0  
**Repository:** https://github.com/Black-Lights/Yojna_Sathi

---

## 📸 App Screenshots

> **Note:** Screenshots are for demonstration purposes. The app is under active development and UI/features may change.

**Available Screenshots:**
- ✅ Splash Screen (`Splash_Screen.jpeg`)
- ✅ Sign In Screen (`Sign_In_Screen.jpeg`)
- ✅ Register Screen (`Register_Screen.jpeg`)
- ✅ Home Page (`Home_page.jpeg`)
- ✅ Agriculture Schemes Page (`Agriculture_Schemes_paage.jpeg`)
- ✅ Profile Page (`Profile_page.jpeg`)
- ✅ Settings Page (`Settings_page.jpeg`)

All screenshots are located in `assets/images/` directory.

---

## ✅ Completed Tasks

### 1. Project Setup & Structure
- ✅ Flutter project initialized with clean architecture
- ✅ Feature-based folder structure implemented
- ✅ Git repository created and pushed to GitHub
- ✅ `.gitignore` configured for Flutter projects
- ✅ Development environment setup (Flutter SDK 3.24.5, Android Studio)

### 2. Core Features Implementation
- ✅ **Authentication Module**
  - Email/Password sign-in and sign-up
  - Phone authentication (UI ready)
  - Google Sign-In (UI ready)
  - Password reset functionality
  - Auth BLoC state management
  - Auth service with Firebase integration

- ✅ **Profile Management**
  - Profile creation page with photo upload
  - Profile edit page with all fields
  - Profile photo upload to Firebase Storage
  - User profile data models with photoUrl support
  - Profile service with Firestore integration
  - BLoC for profile state management
  - CachedNetworkImage for photo display
  - Image compression (512x512, 75% quality)

- ✅ **Home Dashboard**
  - Bottom navigation with 4 tabs
  - Schemes tab with categories
  - Applications tab
  - Tutorials tab
  - Profile tab with user info display

- ✅ **Schemes Module**
  - Scheme list page
  - Scheme detail page
  - Scheme categories (Education, Health, Agriculture, etc.)
  - Search functionality
  - Filter options
  - Eligibility checking logic

- ✅ **Applications Module**
  - Application list page
  - Application detail page
  - Application submission functionality
  - Application status tracking
  - Document upload support

- ✅ **Applications Module** ⭐ NEW - JUST COMPLETED
  - Application list page with status tracking
  - Application detail page with document viewing
  - Application submission with document upload
  - Document upload support (file_picker integration)
  - Status badges (Pending, Under Review, Approved, Rejected)
  - Proper empty state UI
  - User-friendly error messages
  - Client-side sorting (no Firestore index required)
  - Storage service integration for document management

- ✅ **Notifications Module** ⭐ NEW - JUST COMPLETED
  - Firebase Cloud Messaging (FCM) integration
  - Local notifications (flutter_local_notifications)
  - Push notification permissions handling
  - FCM token management and Firestore saving
  - Notification history in Firestore
  - Notifications list page with real-time updates
  - Unread notification badges
  - Mark as read functionality
  - Mark all as read option
  - Notification preferences page in Settings
  - Topic-based subscriptions (new_schemes, application_updates, eligibility_alerts, announcements)
  - Auto-save notification preferences
  - Background and foreground message handling
  - Notification tap navigation

- ✅ **Settings & Preferences**
  - Settings page
  - Notification preferences with toggle switches
  - Topic subscription management
  - Seed data functionality for development

- ✅ **Branding & UI**
  - Custom Yojna Sathi app icons replaced default Flutter icon
  - All Android icon densities (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
  - Splash screen with animation
  - Multi-language support structure
  - Consistent theme and color scheme

### 3. Firebase Integration ✅
- ✅ Firebase project created (yojna-sathi)
- ✅ Firebase Authentication configured
  - Email/Password authentication enabled
  - Test user created: alirehman70612@gmail.com
  - User ID: kn5gVKqTDgXjxty4fYqEj0l0CN93
- ✅ Cloud Firestore database created (asia-south2 - Delhi)
- ✅ Firebase packages updated to latest versions
  - firebase_core: ^3.6.0
  - firebase_auth: ^5.7.0
  - cloud_firestore: ^5.6.12
  - firebase_storage: ^12.4.10
  - firebase_messaging: ^15.2.10
- ✅ Additional packages added
  - image_picker: ^1.1.2 (for profile photo selection)
  - cached_network_image: ^3.4.1 (for image caching)
  - file_picker: ^6.2.1 (for document uploads)
  - flutter_local_notifications: ^17.2.4 (for local notifications)
- ✅ `google-services.json` configured for Android
- ✅ `firebase_options.dart` generated with FlutterFire CLI
- ✅ Firebase Auth type casting bug fixed (Pigeon protocol issue)
- ✅ Android build configuration updated
  - minSdkVersion: 23
  - compileSdk: 35
  - targetSdk: 34
- ✅ Firestore collections structure created
  - users, schemes, user_schemes, tutorials collections defined
  - All data models and services implemented
- ✅ Firestore security rules deployed
- ✅ Firestore indexes deployed for query optimization
- ✅ Seed data script created (10 government schemes)
- ⚠️ Firebase Storage configured but not deployed (requires Blaze plan upgrade)

### 4. Bug Fixes & Optimizations
- ✅ Fixed Firebase Auth Pigeon type casting error
- ✅ Fixed profile tab RangeError when displayName is empty
- ✅ Updated Android build configuration for Firebase compatibility
- ✅ Resolved Gradle build issues
- ✅ Fixed navigation after successful login
- ✅ Fixed null safety issues in profile display
- ✅ Fixed compileSdk version warning (updated to SDK 35)
- ✅ Fixed "For You" section not refreshing after navigation
- ✅ Implemented BLoC state persistence for consistent scheme display
- ✅ Fixed applications module compilation errors (StorageService API mismatch)
- ✅ Fixed Firestore permission denied errors (deployed security rules)
- ✅ Fixed Firestore index requirement errors (removed orderBy, client-side sorting)
- ✅ Fixed ANR (Application Not Responding) issues with notification initialization
- ✅ Improved error handling with user-friendly messages

### 5. Branding & UI Updates
- ✅ App rebranded from SchemaMitra to Yojna Sathi
- ✅ New tagline: "Aapka Adhikaar, Aap Tak"
- ✅ Updated splash screen with new branding
- ✅ Updated home screen with new tagline
- ✅ Updated README and documentation

### 6. Documentation
- ✅ README.md created with setup instructions
- ✅ FIREBASE_SETUP.md created with detailed Firebase setup
- ✅ PROJECT_STATUS.md (this file)
- ✅ Code documentation and comments

---

## 🔄 In Progress

### Current Sprint: Eligibility-Based Scheme Discovery ✅
- ✅ **Comprehensive Schemes Dataset**
  - ✅ Created dataset with 41+ government schemes across 9 categories
  - ✅ Successfully seeded all schemes to Firestore
  - ✅ Schemes include: Agriculture, Education, Health, Housing, Women & Child, Business, Employment, Banking, Social Welfare
- ✅ **Robust Eligibility Matching System**
  - ✅ Enhanced EligibilityService with strict mandatory criteria checking
  - ✅ Gender-based filtering (Male, Female, Transgender specific schemes)
  - ✅ Age range validation (min/max age enforcement)
  - ✅ Category matching (General, SC, ST, OBC, etc.)
  - ✅ Occupation-based eligibility
  - ✅ State/region-based filtering
  - ✅ Education level requirements
  - ✅ Income-based eligibility
  - ✅ Eligibility scoring system (0.0-1.0 match score)
- ✅ **Personalized Recommendations UI**
  - ✅ "For You" section on home page showing top 3 eligible schemes
  - ✅ Eligibility badges with color-coded indicators:
    * Highly Eligible (90%+ match) - Green with verified icon
    * Eligible (70-89% match) - Light green with check icon
    * Partially Eligible (50-69% match) - Orange with info icon
  - ✅ Match percentage display on recommended schemes
  - ✅ Dedicated "For You" page for all eligible schemes
  - ✅ Profile completion prompts when no data found
- ✅ **Firestore Security Rules**
  - ✅ Deployed updated rules allowing authenticated scheme writes
  - ✅ Development-friendly rules with TODO for production restrictions
- ✅ **Testing & Verification**
  - ✅ Successfully tested scheme seeding (41 schemes uploaded)
  - ✅ Testing eligibility matching with real user profiles
  - ✅ Verified gender-based filtering (male users don't see female schemes)
  - ✅ Verified home page refresh mechanism working correctly

---

## 📝 To-Do List

### Phase 1: Core Functionality (MVP)

#### High Priority
1. **Firestore Database Setup** ✅
   - [x] Create Firestore collections structure
     - [x] `users` collection with user profile schema
     - [x] `schemes` collection with scheme data
     - [x] `user_schemes` collection for applications
     - [x] `tutorials` collection for video tutorials
   - [x] Deploy Firestore security rules
   - [x] Firestore indexes deployed
   - [x] Seed data script created (scripts/seed_schemes.dart)
   - [ ] Execute seed data (pending: need to run seed script in app)
   - [ ] Deploy Firebase Storage rules (BLOCKED: requires Blaze plan)

2. **Profile Module Completion**
   - [x] Complete profile creation flow after signup
   - [x] Add profile photo upload to Firebase Storage
   - [x] Implement profile edit page with all fields
   - [ ] Implement profile data validation
   - [x] Save profile data to Firestore
   - [ ] Load profile data on app launch
   - [ ] Add profile completion progress indicator

3. **Schemes Module Enhancement**
   - [x] Schemes BLoC implementation
   - [x] SchemeListPage with search and filtering
   - [x] SchemeDetailPage with comprehensive UI
   - [x] Comprehensive Firestore integration (41+ schemes)
   - [x] Research government APIs (MyScheme.gov.in)
   - [x] Create API service framework (MySchemeApiService)
   - [x] Implement strict eligibility matching algorithm
   - [x] Add scheme filtering by user profile with scoring
   - [x] Personalized "For You" recommendations
   - [x] Gender-based scheme filtering
   - [x] Eligibility badges and visual indicators
   - [ ] Register for MyScheme API credentials at data.gov.in
   - [ ] Complete MyScheme API integration (4,420+ schemes)
   - [ ] Implement real-time scheme updates (daily sync)
   - [ ] Add scheme bookmarking/favorites
   - [ ] Implement scheme search with pagination
   - [ ] Cache API responses in Firestore (offline support)

4. **Application Module**
   - [x] Connect application submission to Firestore
   - [x] Implement document upload to Firebase Storage
   - [x] Add application status updates
   - [x] Implement application history
   - [x] Application submission UI with document picker
   - [x] Check existing applications before reapplying
   - [x] Status badges (Pending, Under Review, Approved, Rejected)
   - [ ] Add application notifications
   - [ ] Implement application detail page with document viewer

#### Medium Priority
5. **Authentication Enhancements**
   - [ ] Complete Phone authentication implementation
   - [ ] Complete Google Sign-In implementation
   - [ ] Add biometric authentication option
   - [ ] Implement session management
   - [ ] Add account deletion functionality

6. **Tutorials Module**
   - [ ] Integrate video player (youtube_player_flutter)
   - [ ] Upload tutorial videos to Firebase Storage or YouTube
   - [ ] Fetch tutorials from Firestore
   - [ ] Add tutorial completion tracking
   - [ ] Implement tutorial search and categories

7. **Notifications** ✅ COMPLETED
   - [x] Set up Firebase Cloud Messaging (FCM)
   - [x] Implement local notifications (flutter_local_notifications)
   - [x] Configure foreground and background message handlers
   - [x] FCM token management and Firestore storage
   - [x] Notification permissions handling (iOS & Android)
   - [x] Create notification history page with real-time updates
   - [x] Implement notification list with unread badges
   - [x] Mark as read functionality
   - [x] Mark all as read option
   - [x] Add notification preferences in settings
   - [x] Topic-based subscriptions (new_schemes, application_updates, eligibility_alerts, announcements)
   - [x] Auto-save notification settings to Firestore
   - [x] Notification tap navigation
   - [x] Empty state UI for notifications
   - [x] Client-side sorting (no Firestore index required)

8. **Offline Support**
   - [ ] Implement Hive local database
   - [ ] Cache schemes for offline viewing
   - [ ] Cache user profile data
   - [ ] Add sync mechanism when online
   - [ ] Show offline indicator in UI

#### Low Priority
9. **UI/UX Improvements**
   - [ ] Add loading shimmer effects
   - [ ] Implement pull-to-refresh
   - [ ] Add empty state illustrations
   - [ ] Improve error messages
   - [ ] Add onboarding screens
   - [ ] Implement dark mode

10. **Settings & Preferences**
    - [ ] Language selection (Hindi/English)
    - [x] Notification preferences page
    - [x] Notification topic subscriptions
    - [x] Toggle switches for notification types
    - [x] Auto-save preferences to Firestore
    - [ ] About app section
    - [ ] Privacy policy
    - [ ] Terms of service
    - [ ] App version and updates

---

## ⚠️ Known Issues & Blockers

### Critical Blockers
1. **Firebase Storage Not Available - Requires Blaze Plan Upgrade**
   - **Issue**: Firebase Storage (for profile photos and documents) requires Blaze (pay-as-you-go) plan
   - **Current Plan**: Spark (free tier) - Storage not available
   - **Impact**: 
     - Profile photo upload feature implemented but cannot be tested
     - Document upload for scheme applications blocked
     - Storage security rules ready but cannot be deployed
   - **Workaround**: None - must upgrade to Blaze plan
   - **Action Required**: 
     1. Go to Firebase Console → Settings → Usage and billing
     2. Upgrade to Blaze plan (Pay as you go)
     3. Run: `firebase deploy --only storage`
     4. Test profile photo upload in app
   - **Cost**: Firebase Blaze has generous free tier (5GB storage, 1GB download/day)
   - **Status**: ⏳ Pending upgrade decision

### Non-Critical Issues
- None currently

---

### Phase 2: Advanced Features

1. **AI/ML Integration**
   - [ ] Implement eligibility prediction model
   - [ ] Add chatbot for scheme queries
   - [ ] Document OCR for automatic data extraction

2. **Social Features**
   - [ ] Share schemes with friends
   - [ ] Success stories section
   - [ ] Community forum
   - [ ] Reviews and ratings

3. **Admin Panel**
   - [ ] Web admin panel for scheme management
   - [ ] Analytics dashboard
   - [ ] User management
   - [ ] Application approval system

4. **Localization**
   - [ ] Complete Hindi translations
   - [ ] Add regional language support
   - [ ] RTL support for Urdu

5. **Performance Optimization**
   - [ ] Image caching and optimization
   - [ ] Lazy loading for lists
   - [ ] Background sync
   - [ ] App size optimization

### Phase 3: Testing & Deployment

1. **Testing**
   - [ ] Unit tests for business logic
   - [ ] Widget tests for UI components
   - [ ] Integration tests for user flows
   - [ ] Firebase emulator testing
   - [ ] Performance testing
   - [ ] Security audit

2. **Deployment**
   - [ ] Android app signing
   - [ ] iOS provisioning profiles
   - [ ] Google Play Store listing
   - [ ] Apple App Store listing
   - [ ] Beta testing with TestFlight/Play Console
   - [ ] Production release

3. **Post-Launch**
   - [ ] User feedback collection
   - [ ] Analytics integration (Firebase Analytics)
   - [ ] Crash reporting (Firebase Crashlytics)
   - [ ] A/B testing for features
   - [ ] Regular updates and maintenance

---

## 🐛 Known Issues

### Critical
- **Firebase Storage Access Blocked**: Requires Blaze plan upgrade
  - Impact: Profile photo upload, document uploads disabled
  - Workaround: Using default avatars until upgrade
  - Status: Pending billing setup

- **MyScheme API Access Pending**: API credentials required
  - Impact: Using limited seed data (10 schemes) instead of 4,420+ schemes
  - Workaround: Local Firestore with manually curated schemes
  - Action Required: Register at data.gov.in and contact MyScheme support
  - See: SCHEME_API_INTEGRATION.md for details

### Minor
- Google Play Services warnings in emulator (expected in emulator environment)
- OnBackInvokedCallback warnings (can be enabled in AndroidManifest if needed)

---

## 🔧 Technical Debt

1. **Code Quality**
   - Add comprehensive error handling in all services
   - Implement proper logging mechanism
   - Add code documentation for complex functions
   - Refactor repeated code into utilities

2. **Architecture**
   - Consider repository pattern implementation
   - Add use cases layer for complex business logic
   - Implement proper dependency injection with get_it

3. **Testing**
   - Add test coverage for critical paths
   - Set up CI/CD pipeline
   - Automated testing in pull requests

---

## 📊 Project Statistics

- **Total Dart Files:** 45+
- **Total Pages:** 14
- **Features Modules:** 9
- **BLoC Implementations:** 3
- **Firebase Services:** 5 (Auth, Firestore, Storage, Messaging, Cloud Functions planned)
- **Lines of Code:** ~3000+
- **Test Coverage:** 0% (to be implemented)

---

## 🎯 Sprint Goals

### Current Sprint (Week 1)
- [x] Fix Firebase authentication issues
- [x] Test complete signup and login flow
- [x] Update documentation
- [ ] Set up Firestore database structure
- [ ] Implement profile data saving to Firestore

### Next Sprint (Week 2)
- [ ] Complete profile creation flow
- [ ] Fetch and display schemes from Firestore
- [ ] Implement scheme search and filters
- [ ] Add scheme bookmarking

---

## 👥 Team

- **Developer:** Ali Rehman
- **GitHub:** [@Black-Lights](https://github.com/Black-Lights)
- **Repository:** [Yojna_Sathi](https://github.com/Black-Lights/Yojna_Sathi)

---

## 📅 Timeline

- **Project Start:** November 2025
- **Firebase Setup Completed:** November 17, 2025
- **Target MVP:** December 2025
- **Target Beta Release:** January 2026
- **Target Production Release:** February 2026

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [BLoC Pattern Guide](https://bloclibrary.dev/)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture/)

---

## 🔄 Recent Updates

### November 18, 2025 (Evening) - Notifications Module Complete ✅
- ✅ **FCM Integration**: Full Firebase Cloud Messaging setup with local notifications
- ✅ **Notification Service**: Comprehensive service handling foreground, background, and terminated states
- ✅ **Notifications UI**: 
  - Real-time notification list with StreamBuilder
  - Unread badges and color-coded indicators
  - Mark as read/Mark all as read functionality
  - Empty state with proper messaging
  - Notification tap navigation to relevant screens
- ✅ **Notification Preferences**: 
  - Settings page with toggle switches for 4 notification types
  - FCM topic subscriptions (new_schemes, application_updates, eligibility_alerts, announcements)
  - Auto-save to Firestore
  - User-friendly info cards
- ✅ **Custom App Icons**: Replaced default Flutter icon with Yojna Sathi logo across all Android densities
- ✅ **Bug Fixes**:
  - Fixed ANR (Application Not Responding) by moving initialization to async
  - Removed Firestore orderBy to avoid index requirement (client-side sorting)
  - Fixed Firestore permission issues
  - Proper error handling and try-catch blocks
- ✅ **Firestore Rules**: Deployed updated rules for notifications collection
- ✅ **Git**: All changes committed to feature/notifications-module branch

### November 18, 2025 (Afternoon) - Eligibility-Based Discovery System
- ✅ **Comprehensive Scheme Database**: Seeded 41+ government schemes across 9 categories to Firestore
- ✅ **Enhanced Eligibility Matching**: Implemented strict mandatory criteria checking including:
  - Gender-based filtering (prevents showing female-only schemes to male users)
  - Age range validation (min/max age requirements)
  - Category, occupation, state, education matching
  - Eligibility scoring system (0.0-1.0)
- ✅ **Personalized UI**: 
  - "For You" section on home page with top 3 recommendations
  - Eligibility badges (Highly Eligible, Eligible, Partially Eligible)
  - Match percentage display
  - Dedicated "For You" page
- ✅ **Fixed Critical Bug**: Female-specific schemes no longer shown to male users
- ✅ **Firestore Rules**: Updated security rules to allow authenticated scheme writes
- ✅ **Added Gender Field**: Extended Eligibility model to include gender array with complex parsing (e.g., "Female (pregnant women)")

### November 17, 2025
- ✅ Fixed Firebase Auth Pigeon protocol type casting error
- ✅ Updated Firebase packages to latest versions (firebase_auth 5.7.0)
- ✅ Fixed minSdkVersion compatibility (updated to 23)
- ✅ Fixed profile tab display name error
- ✅ Tested and verified complete authentication flow
- ✅ User successfully signed up and logged in
- ✅ Created comprehensive project documentation

---

*Last Updated: November 18, 2025*
