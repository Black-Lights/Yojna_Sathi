# SchemaMitra - Government Scheme Eligibility & Application Flutter App

![SchemaMitra Logo](assets/logos/logo.png)

**Tagline:** Aapka Haq, Aapke Haath Mein

A comprehensive Flutter mobile application that enables Indian citizens to discover, match, and apply for central and state government schemes. The app features personalized profile creation, automatic eligibility matching, direct application options, offline browsing, new scheme notifications, and tutorial guides.

## 📱 Features

- **User Authentication**: Email, Phone, and Google sign-in options
- **Profile Management**: Create and manage detailed user profiles
- **Scheme Discovery**: Browse and search thousands of government schemes
- **Eligibility Matching**: Automatic matching based on user profile
- **Application Tracking**: Apply for schemes and track application status
- **Document Upload**: Upload required documents for applications
- **Tutorial Videos**: Step-by-step guides for scheme applications
- **Offline Support**: Access schemes and tutorials offline
- **Notifications**: Get notified about new schemes
- **Multi-language**: Support for Hindi and English

## 🏗️ Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: BLoC Pattern
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Storage
  - Cloud Messaging (FCM)
- **Local Storage**: Hive
- **Architecture**: Clean Architecture with feature-based structure

## 📁 Project Structure

```
lib/
├── config/
│   ├── routes/          # App routing configuration
│   └── theme/           # Theme and styling
├── core/
│   ├── di/              # Dependency injection
│   ├── services/        # Core services (eligibility, storage)
│   └── utils/           # Constants and utilities
├── features/
│   ├── auth/            # Authentication feature
│   ├── profile/         # User profile management
│   ├── schemes/         # Scheme browsing and details
│   ├── applications/    # Application management
│   ├── tutorials/       # Tutorial videos
│   ├── notifications/   # Push notifications
│   ├── settings/        # App settings
│   ├── home/            # Home dashboard
│   └── splash/          # Splash screen
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Scheme_Website
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Add Android and iOS apps to your Firebase project
   
   c. Download configuration files:
      - `google-services.json` for Android → Place in `android/app/`
      - `GoogleService-Info.plist` for iOS → Place in `ios/Runner/`
   
   d. Update `lib/firebase_options.dart` with your Firebase configuration
   
   e. Enable Authentication methods:
      - Email/Password
      - Phone
      - Google Sign-In
   
   f. Create Firestore database with the following collections:
      - users
      - schemes
      - user_schemes
      - tutorials
      - scheme_launches
   
   g. Deploy Firestore and Storage rules:
      ```bash
      firebase deploy --only firestore:rules
      firebase deploy --only storage:rules
      ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

### Adding Fonts

Place Poppins font files in `assets/fonts/` directory:
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`

### Adding Assets

Create the following asset directories:
```
assets/
├── images/
├── icons/
├── animations/
└── logos/
```

## 📊 Database Schema

### Users Collection
```json
{
  "userId": "string",
  "profile": {
    "name": "string",
    "age": "number",
    "gender": "string",
    "email": "string",
    "phone": "string",
    "income": "string",
    "occupation": "string",
    "category": "string",
    "education": "string",
    "specialConditions": ["array"],
    "location": {
      "state": "string",
      "district": "string",
      "village": "string",
      "latitude": "number",
      "longitude": "number"
    }
  }
}
```

### Schemes Collection
```json
{
  "schemeId": "string",
  "name": "string",
  "ministry": "string",
  "category": "string",
  "description": "string",
  "eligibility": {
    "minAge": "number",
    "maxAge": "number",
    "incomeMax": "string",
    "categories": ["array"],
    "occupations": ["array"],
    "states": ["array"]
  },
  "benefits": {
    "amount": "number",
    "type": "string",
    "description": "string"
  }
}
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔐 Security

- All user data is protected by Firebase Authentication
- Firestore security rules restrict data access
- Sensitive documents are encrypted in Cloud Storage
- All API calls use HTTPS/TLS

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👥 Team

- Project Lead: [Your Name]
- Developers: [Team Members]

## 📞 Support

For support, email support@schemamitra.com or join our Slack channel.

## 🗺️ Roadmap

- [ ] Integrate Aadhaar eKYC API
- [ ] Add more regional languages
- [ ] Implement AI-based scheme recommendations
- [ ] GIS/map integration for location-based benefits
- [ ] Offline CSC verification
- [ ] Admin panel for scheme management

## 📸 Screenshots

(Add screenshots of your app here)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Government of India for scheme data
- All contributors and supporters

---

**SchemaMitra** - Making government schemes accessible to every citizen
