# Government Scheme API Integration

## Overview

Yojna Sathi integrates with official Government of India APIs to provide real-time, accurate scheme information to users.

---

## Official Data Sources

### 1. **MyScheme.gov.in** (Primary Source) ⭐
- **Website**: https://www.myscheme.gov.in/
- **Schemes**: 4,420+ (590+ Central, 3,830+ State/UT)
- **Categories**: 13 major categories
- **Features**: 
  - Eligibility-based scheme matching
  - Real-time scheme updates
  - Application guidance
  - Multi-language support

### 2. **Data.gov.in** (API Provider)
- **Website**: https://www.data.gov.in/
- **Resources**: 481,599 datasets
- **APIs**: 236,285+ APIs available
- **Access**: Free with registration

---

## Integration Strategy

### Current Implementation (v1.0)

#### **Hybrid Approach**
We use a **hybrid model** combining:

1. **Local Firestore Database** (Current)
   - Pre-seeded with top 10 popular schemes
   - Fast, offline-capable
   - No API dependency
   - Updated manually/periodically

2. **MyScheme API Integration** (Planned - v1.1)
   - Real-time scheme data
   - Eligibility-based filtering
   - Automatic updates
   - Comprehensive scheme coverage

#### **Why Hybrid?**
- ✅ **Reliability**: Works offline with local data
- ✅ **Performance**: Instant loading from Firestore
- ✅ **Freshness**: API integration for latest schemes
- ✅ **Fallback**: Local data if API unavailable

---

## API Integration Steps

### Phase 1: Setup (Required Before API Integration)

#### Step 1: Register for API Access

**Option A: MyScheme Portal**
1. Visit: https://www.myscheme.gov.in/
2. Contact: support-myscheme@digitalindia.gov.in
3. Request API access for mobile app integration
4. Provide:
   - App name: Yojna Sathi
   - Purpose: Scheme discovery mobile application
   - Expected usage: ~1000 requests/day initially

**Option B: Data.gov.in**
1. Visit: https://www.data.gov.in/
2. Click "LOGIN | REGISTER"
3. Register with valid credentials
4. Navigate to "APIs" section
5. Request API key for scheme datasets

#### Step 2: Get API Credentials
You will receive:
```
API Key: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Base URL: https://api.myscheme.gov.in/v1
Documentation: [API Docs Link]
Rate Limit: 1000 requests/day (free tier)
```

#### Step 3: Update the Code
Edit `lib/features/schemes/data/services/my_scheme_api_service.dart`:

```dart
static const String _baseUrl = 'YOUR_ACTUAL_API_URL';
static const String _apiKey = 'YOUR_ACTUAL_API_KEY';
```

### Phase 2: Implementation

Once API access is granted, the app will:

1. **Fetch Latest Schemes**
   ```dart
   // Automatic sync every 24 hours
   await mySchemeService.fetchAllSchemes();
   ```

2. **Eligibility Matching**
   ```dart
   // Match schemes to user profile
   final eligibleSchemes = await mySchemeService.fetchEligibleSchemes(
     age: userProfile.age,
     gender: userProfile.gender,
     state: userProfile.state,
     category: userProfile.category,
     occupation: userProfile.occupation,
     income: userProfile.income,
     education: userProfile.education,
   );
   ```

3. **Cache & Sync**
   - Schemes cached in Firestore
   - Synced every 24 hours
   - Manual refresh available

---

## API Endpoints (Expected)

Based on MyScheme.gov.in structure:

### 1. Get All Schemes
```http
GET /api/v1/schemes
Headers:
  api-key: YOUR_API_KEY
  Content-Type: application/json

Response:
{
  "schemes": [
    {
      "scheme_id": "pm-kisan-2024",
      "name": "PM-KISAN",
      "ministry": "Agriculture",
      "category": "Agriculture",
      "benefits": {...},
      "eligibility": {...},
      ...
    }
  ],
  "total": 4420,
  "page": 1
}
```

### 2. Get Schemes by Category
```http
GET /api/v1/schemes?category=Agriculture
Headers:
  api-key: YOUR_API_KEY
```

### 3. Get Eligible Schemes (Key Feature)
```http
POST /api/v1/schemes/eligible
Headers:
  api-key: YOUR_API_KEY
  Content-Type: application/json

Body:
{
  "age": 35,
  "gender": "Male",
  "state": "Maharashtra",
  "category": "General",
  "occupation": "Farmer",
  "income": "Below 2 Lakh",
  "education": "Graduate"
}

Response:
{
  "eligible_schemes": [...],
  "match_score": 0.85,
  "total_matched": 45
}
```

### 4. Get Scheme Details
```http
GET /api/v1/schemes/{scheme_id}
Headers:
  api-key: YOUR_API_KEY
```

---

## Alternative Approaches

### If Official API Not Available

#### 1. **Web Scraping** (Not Recommended)
- ❌ Violates terms of service
- ❌ Unreliable (breaks with website updates)
- ❌ Performance issues
- ❌ Legal concerns

#### 2. **Manual Data Collection**
- ✅ Compile from official sources
- ✅ Store in Firestore
- ✅ Update quarterly
- ❌ Labor-intensive
- ❌ May become outdated

#### 3. **Third-Party APIs**
- ❌ No reliable third-party for Indian schemes
- ❌ Data accuracy concerns
- ❌ Licensing issues

#### 4. **Government Open Data**
- ✅ Download datasets from data.gov.in
- ✅ Process and import to Firestore
- ✅ Legal and free
- ❌ Not real-time
- ❌ Manual updates needed

---

## Recommended Approach for Production

### Short-term (Current - v1.0)
1. ✅ Use local Firestore with manually curated schemes
2. ✅ Focus on top 100 popular schemes
3. ✅ Update quarterly from official websites
4. ✅ Perfect for MVP and testing

### Long-term (v1.1+)
1. 📧 Apply for MyScheme API access
2. ⚙️ Integrate API for real-time data
3. 💾 Cache in Firestore for offline access
4. 🔄 Auto-sync daily
5. 📊 Analytics on scheme popularity

---

## Data Quality & Maintenance

### Current Data Source
- **Schemes**: 10 popular schemes (manually curated)
- **Data**: From official government websites
- **Accuracy**: High (verified from official sources)
- **Update Frequency**: Manual (as needed)

### With API Integration
- **Schemes**: 4,420+ (all schemes)
- **Data**: Direct from MyScheme.gov.in
- **Accuracy**: 100% (government maintained)
- **Update Frequency**: Real-time

---

## Cost Analysis

### Option 1: MyScheme API (Official)
- **Cost**: FREE (government service)
- **Rate Limit**: 1000 req/day (free tier)
- **Reliability**: High
- **Support**: Government support

### Option 2: Data.gov.in Datasets
- **Cost**: FREE (open data)
- **Format**: CSV/JSON downloads
- **Frequency**: Updated periodically
- **Processing**: Manual import needed

### Option 3: Firestore Only (Current)
- **Cost**: Firebase pricing
  - Free: 50K reads/day
  - Paid: $0.06 per 100K reads
- **Maintenance**: Manual updates
- **Offline**: Fully supported

---

## Next Steps

1. **Immediate** (For Testing)
   - ✅ Use current Firestore implementation
   - ✅ Seed 10 popular schemes
   - ✅ Test eligibility matching locally

2. **This Week**
   - 📧 Email support-myscheme@digitalindia.gov.in for API access
   - 📋 Register at data.gov.in for backup API keys
   - 📝 Document API requirements

3. **After API Access**
   - ⚙️ Implement MySchemeApiService
   - 🧪 Test API integration
   - 🔄 Set up sync mechanism
   - 🚀 Deploy to production

---

## Contact Information

### For API Access
- **MyScheme Support**: support-myscheme@digitalindia.gov.in
- **Phone**: (011) 24303714 (9:00 AM to 5:30 PM)
- **Address**: 4th Floor, NeGD, Electronics Niketan, 6 CGO Complex, Lodhi Road, New Delhi - 110003

### For Data Access
- **Data.gov.in Help**: https://www.data.gov.in/help
- **Community**: https://artefacts.data.gov.in/communities/
- **Suggest Dataset**: https://www.data.gov.in/Suggest_Dataset

---

## Legal & Compliance

- ✅ Using official government data
- ✅ Compliant with Government Open Data License - India (GODL)
- ✅ Proper attribution to data sources
- ✅ No web scraping or unauthorized access
- ✅ Free for public benefit applications

---

**Last Updated**: November 18, 2025  
**Status**: Awaiting API credentials from MyScheme.gov.in
