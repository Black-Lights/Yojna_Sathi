# Quick Guide: Getting MyScheme API Access

This guide will help you register for MyScheme.gov.in API access to enable real-time government scheme data in the Yojna Sathi app.

---

## Why Do We Need This?

Currently, the app uses **10 manually added schemes**. With MyScheme API, you'll get:
- **4,420+ government schemes** (590 Central + 3,830 State/UT)
- **Automatic eligibility matching** based on user profile
- **Real-time updates** when new schemes are announced
- **All 13 categories** (Agriculture, Education, Health, Housing, etc.)

---

## Step-by-Step Registration

### Option 1: Email MyScheme Support (Recommended)

1. **Send an Email To:**
   ```
   support-myscheme@digitalindia.gov.in
   ```

2. **Email Subject:**
   ```
   API Access Request for Mobile App - Yojna Sathi
   ```

3. **Email Body Template:**
   ```
   Dear MyScheme Team,

   I am developing a mobile application called "Yojna Sathi" to help citizens discover 
   and apply for government schemes based on their eligibility.

   App Details:
   - Name: Yojna Sathi (Your Right, To You)
   - Platform: Flutter (Android & iOS)
   - Purpose: Help citizens find eligible government schemes
   - Features: Eligibility-based scheme matching, application guidance, multilingual support
   - Expected Usage: ~1000 API requests/day initially
   - Developer: [Your Name]
   - GitHub: https://github.com/Black-Lights/Yojna_Sathi

   I would like to request API access to integrate MyScheme data into our mobile app.
   Could you please provide:
   1. API documentation
   2. API key/credentials
   3. Rate limits and usage guidelines
   4. Any terms of service for API usage

   This is a non-commercial, public benefit application aimed at increasing scheme awareness
   among Indian citizens.

   Thank you for your support!

   Best regards,
   [Your Name]
   [Your Contact Number]
   [Your Email]
   ```

4. **Wait for Response** (Usually 3-5 business days)

---

### Option 2: Register at Data.gov.in

1. **Visit:** https://www.data.gov.in/

2. **Click** "LOGIN | REGISTER" (top right corner)

3. **Fill Registration Form:**
   - Full Name
   - Email
   - Mobile Number
   - Organization (Optional - can write "Independent Developer")
   - Purpose: "Mobile App Development - Government Scheme Discovery"

4. **Verify Your Email** (Check inbox for verification link)

5. **Login** to your account

6. **Navigate** to "APIs" section

7. **Search** for "MyScheme" or "Government Schemes"

8. **Request API Key:**
   - Click on relevant API
   - Fill purpose form
   - Submit request
   - Wait for approval (3-7 days)

---

### Option 3: Call MyScheme Office

**Phone:** (011) 24303714  
**Timings:** 9:00 AM to 5:30 PM (Monday to Friday)

**What to Say:**
> "Hello, I'm developing a mobile app called Yojna Sathi to help citizens find eligible 
> government schemes. I would like to request API access to integrate MyScheme data. 
> How can I proceed?"

---

## What You'll Receive

After approval, you should get:

```
API Base URL: https://api.myscheme.gov.in/v1 (example)
API Key: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Documentation: [Link to API docs]
Rate Limit: X requests per day
Support Email: [Support contact]
```

---

## After You Get the Credentials

### Step 1: Update the Code

Open `lib/features/schemes/data/services/my_scheme_api_service.dart` and update:

```dart
static const String _baseUrl = 'YOUR_ACTUAL_API_URL_HERE';
static const String _apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

### Step 2: Test the API

Run the app and check if schemes are loading from the API:

```powershell
flutter run
```

### Step 3: Remove Seed Data

Once API is working, you can remove the "Seed Schemes Data" button from settings:
- Open `lib/features/settings/presentation/pages/settings_page.dart`
- Comment out or remove the seed button section

### Step 4: Update Documentation

- Mark API integration as complete in PROJECT_STATUS.md
- Update README with API setup instructions

---

## While Waiting for API Access

### Use Current Implementation (10 Seed Schemes)

The app already works with 10 popular schemes:
1. PM-KISAN (Agriculture)
2. Ayushman Bharat (Health)
3. Sukanya Samriddhi Yojana (Women & Child)
4. Pradhan Mantri Awas Yojana (Housing)
5. MUDRA Yojana (Business)
6. National Scholarship Portal (Education)
7. PM Fasal Bima Yojana (Agriculture)
8. Stand Up India (Women & Child)
9. Atal Pension Yojana (Social Welfare)
10. Beti Bachao Beti Padhao (Women & Child)

### How to Add More Schemes Manually

If you want to add more schemes while waiting:

1. **Open:** `lib/features/settings/presentation/pages/settings_page.dart`

2. **Find** the `_getInitialSchemes()` method

3. **Add new schemes** following this structure:

```dart
{
  'name': 'Scheme Name',
  'ministry': 'Ministry Name',
  'category': 'Category', // Agriculture, Health, Education, etc.
  'description': 'Detailed description',
  'benefits': {
    'financial': 'Money benefits',
    'nonFinancial': 'Other benefits',
  },
  'eligibility': {
    'age': 'Age criteria',
    'income': 'Income criteria',
    'occupation': 'Who can apply',
    'education': 'Education needed',
  },
  'state': 'All India', // or specific state
  'applicationUrl': 'https://official-scheme-website.gov.in',
  'documentsRequired': ['Document 1', 'Document 2'],
  'applicationProcess': 'How to apply',
  'importantDates': 'Deadlines if any',
  'isActive': true,
},
```

4. **Tap** "Seed Schemes Data" in the app to upload new schemes

---

## Alternative: Download Scheme Datasets

If API access takes too long, you can:

### 1. Download from Data.gov.in

- Visit: https://www.data.gov.in/
- Search: "government schemes"
- Download: CSV/JSON files
- Import: Process and add to Firestore

### 2. Visit MyScheme Website

- Visit: https://www.myscheme.gov.in/
- Browse: All scheme categories
- Copy: Official scheme details
- Add: To `_getInitialSchemes()` method

---

## Helpful Resources

### Official Links
- **MyScheme Portal:** https://www.myscheme.gov.in/
- **Data.gov.in:** https://www.data.gov.in/
- **Digital India:** https://digitalindia.gov.in/

### Categories on MyScheme
- Agriculture, Rural & Environment: 755 schemes
- Banking, Financial Services & Insurance: 101 schemes
- Business & Entrepreneurship: 643 schemes
- Education & Learning: 1071 schemes
- Health & Wellness: 261 schemes
- Housing & Shelter: 123 schemes
- Public Safety, Law & Justice: 62 schemes
- Science, IT & Communications: 87 schemes
- Skills & Employment: 361 schemes
- Social Welfare & Empowerment: 1461 schemes
- Sports & Culture: 34 schemes
- Transport & Infrastructure: 15 schemes
- Travel & Tourism: 16 schemes
- Women & Child: 446 schemes

### Contact Information
- **Email:** support-myscheme@digitalindia.gov.in
- **Phone:** (011) 24303714
- **Address:** 4th Floor, NeGD, Electronics Niketan, 6 CGO Complex, Lodhi Road, New Delhi - 110003

---

## Expected Timeline

- **Email Response:** 3-5 business days
- **Data.gov.in Approval:** 3-7 business days
- **Total Time:** 1-2 weeks on average

**Tip:** Send emails to both support-myscheme@digitalindia.gov.in AND register at data.gov.in simultaneously to speed up the process.

---

## Questions?

If you face any issues:
1. Check SCHEME_API_INTEGRATION.md for detailed technical documentation
2. Review PROJECT_STATUS.md for current implementation status
3. Check the code comments in `my_scheme_api_service.dart`

---

**Good luck with the API registration! 🚀**

Once you get the credentials, the app will automatically fetch 4,420+ schemes with eligibility matching.
