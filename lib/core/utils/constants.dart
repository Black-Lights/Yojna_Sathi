class AppConstants {
  // App Info
  static const String appName = 'SchemaMitra';
  static const String appTagline = 'Aapka Haq, Aapke Haath Mein';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String schemesCollection = 'schemes';
  static const String userSchemesCollection = 'user_schemes';
  static const String tutorialsCollection = 'tutorials';
  static const String launchesCollection = 'scheme_launches';
  
  // Storage Paths
  static const String documentsPath = 'documents';
  static const String videosPath = 'videos';
  static const String imagesPath = 'images';
  
  // Hive Boxes
  static const String schemesBox = 'schemes_box';
  static const String tutorialsBox = 'tutorials_box';
  static const String userBox = 'user_box';
  
  // Shared Preferences Keys
  static const String languageKey = 'language';
  static const String notificationKey = 'notifications_enabled';
  static const String themeKey = 'theme_mode';
  
  // Application Status
  static const String statusEligible = 'eligible';
  static const String statusNotEligible = 'not_eligible';
  static const String statusMayBeEligible = 'may_be_eligible';
  static const String statusApplied = 'applied';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusPending = 'pending';
  
  // Income Ranges
  static const List<String> incomeRanges = [
    'Below 1L',
    '1-2L',
    '2-5L',
    '5-10L',
    'Above 10L',
  ];
  
  // Categories
  static const List<String> categories = [
    'General',
    'SC',
    'ST',
    'OBC',
  ];
  
  // Occupations
  static const List<String> occupations = [
    'Farmer',
    'Student',
    'Unemployed',
    'Self Employed',
    'Private Sector',
    'Government Employee',
    'Business Owner',
    'Daily Wage Worker',
    'Other',
  ];
  
  // Education Levels
  static const List<String> educationLevels = [
    'Below 10th',
    '10th Pass',
    '12th Pass',
    'Graduate',
    'Post Graduate',
    'Illiterate',
  ];
  
  // Special Conditions
  static const List<String> specialConditions = [
    'disability',
    'widow',
    'senior_citizen',
    'minority',
    'below_poverty_line',
  ];
  
  // Scheme Categories
  static const List<String> schemeCategories = [
    'Agriculture',
    'Education',
    'Health',
    'Housing',
    'Women & Child',
    'Employment',
    'Social Welfare',
    'Financial Assistance',
    'Business & Entrepreneurship',
    'Skill Development',
  ];
  
  // Indian States
  static const List<String> indianStates = [
    'All',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
  
  // Document Types
  static const List<String> documentTypes = [
    'Aadhaar',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport',
    'Ration Card',
    'Income Certificate',
    'Caste Certificate',
    'Bank Passbook',
    'Land Records',
    'Educational Certificate',
    'Other',
  ];
  
  // API Endpoints
  static const String mySchemeApiBase = 'https://api.myscheme.gov.in';
  static const String pibUrl = 'https://pib.gov.in';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);
}
