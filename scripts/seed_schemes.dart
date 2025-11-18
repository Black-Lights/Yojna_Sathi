import 'package:cloud_firestore/cloud_firestore.dart';
import '../lib/features/schemes/data/models/scheme.dart';

/// Script to seed initial government schemes data into Firestore
/// Run this script once to populate the schemes collection with initial data
/// 
/// Usage: dart run scripts/seed_schemes.dart

Future<void> seedSchemes(FirebaseFirestore firestore) async {
  final schemes = _getInitialSchemes();
  
  print('Starting to seed ${schemes.length} schemes...');
  
  int successCount = 0;
  int errorCount = 0;
  
  for (var scheme in schemes) {
    try {
      await firestore
          .collection('schemes')
          .doc(scheme.schemeId)
          .set(scheme.toFirestore());
      successCount++;
      print('✓ Added: ${scheme.name}');
    } catch (e) {
      errorCount++;
      print('✗ Failed to add ${scheme.name}: $e');
    }
  }
  
  print('\n═══════════════════════════════════════');
  print('Seeding completed!');
  print('Success: $successCount');
  print('Errors: $errorCount');
  print('═══════════════════════════════════════\n');
}

List<Scheme> _getInitialSchemes() {
  return [
    // 1. PM Kisan Samman Nidhi
    Scheme(
      schemeId: 'pm-kisan-2024',
      name: 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN)',
      ministry: 'Ministry of Agriculture and Farmers Welfare',
      category: 'Agriculture',
      description: 'PM-KISAN provides income support of ₹6,000 per year to all landholding farmer families across the country in three equal installments of ₹2,000 each every four months.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: null,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['Farmer', 'Agricultural Worker'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 6000,
        type: 'Direct Cash Transfer',
        frequency: 'Yearly',
        description: '₹6,000 per year in three equal installments of ₹2,000 each',
      ),
      applicationProcess: 'Apply online through PM-KISAN portal or visit nearest Common Service Centre (CSC)',
      documentsRequired: [
        'Aadhaar Card',
        'Land ownership documents',
        'Bank account details',
        'Passport size photograph',
      ],
      officialLink: 'https://pmkisan.gov.in/',
      launchDate: DateTime(2018, 12, 1),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 2. Ayushman Bharat - PMJAY
    Scheme(
      schemeId: 'ayushman-bharat-2024',
      name: 'Ayushman Bharat - Pradhan Mantri Jan Arogya Yojana (PMJAY)',
      ministry: 'Ministry of Health and Family Welfare',
      category: 'Health',
      description: 'World\'s largest health insurance scheme providing health cover of ₹5 lakh per family per year for secondary and tertiary care hospitalization.',
      eligibility: Eligibility(
        minAge: null,
        maxAge: null,
        incomeMax: 'BPL',
        categories: ['SC', 'ST', 'OBC', 'General'],
        occupations: ['All'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 500000,
        type: 'Health Insurance',
        frequency: 'Yearly',
        description: 'Health cover of ₹5 lakh per family per year',
      ),
      applicationProcess: 'Check eligibility on PMJAY website using mobile number or SECC Ration Card number',
      documentsRequired: [
        'Aadhaar Card',
        'Ration Card',
        'Proof of income',
        'Family details',
      ],
      officialLink: 'https://pmjay.gov.in/',
      launchDate: DateTime(2018, 9, 23),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 3. Sukanya Samriddhi Yojana
    Scheme(
      schemeId: 'sukanya-samriddhi-2024',
      name: 'Sukanya Samriddhi Yojana (SSY)',
      ministry: 'Ministry of Finance',
      category: 'Women & Child Development',
      description: 'A small deposit scheme for the girl child offering attractive interest rates and tax benefits. Accounts can be opened in the name of a girl child until she attains the age of 10 years.',
      eligibility: Eligibility(
        minAge: 0,
        maxAge: 10,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['All'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 250000,
        type: 'Savings Scheme',
        frequency: 'Maturity',
        description: 'High interest rate (currently 8.0% p.a.) with tax benefits under Section 80C',
      ),
      applicationProcess: 'Visit any authorized bank or post office with required documents',
      documentsRequired: [
        'Girl child\'s birth certificate',
        'Parent/Guardian\'s identity proof',
        'Parent/Guardian\'s address proof',
        'Passport size photographs',
      ],
      officialLink: 'https://www.india.gov.in/spotlight/sukanya-samriddhi-yojana',
      launchDate: DateTime(2015, 1, 22),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 4. Pradhan Mantri Awas Yojana
    Scheme(
      schemeId: 'pmay-urban-2024',
      name: 'Pradhan Mantri Awas Yojana - Urban (PMAY-U)',
      ministry: 'Ministry of Housing and Urban Affairs',
      category: 'Housing',
      description: 'PMAY-U aims to provide affordable housing to all eligible families/beneficiaries in urban areas by year 2022. Interest subsidy on home loans and assistance for new house construction.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: null,
        incomeMax: '18 Lakh',
        categories: ['EWS', 'LIG', 'MIG-I', 'MIG-II'],
        occupations: ['All'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 267000,
        type: 'Interest Subsidy',
        frequency: 'One-time',
        description: 'Interest subsidy up to ₹2.67 lakh on home loans',
      ),
      applicationProcess: 'Apply online through PMAY official portal or visit nearest CSC',
      documentsRequired: [
        'Aadhaar Card',
        'Income certificate',
        'Property documents',
        'Bank account details',
        'Caste certificate (if applicable)',
      ],
      officialLink: 'https://pmaymis.gov.in/',
      launchDate: DateTime(2015, 6, 25),
      deadline: DateTime(2025, 12, 31),
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 5. Pradhan Mantri Mudra Yojana
    Scheme(
      schemeId: 'pmmy-2024',
      name: 'Pradhan Mantri Mudra Yojana (PMMY)',
      ministry: 'Ministry of Finance',
      category: 'Business & Entrepreneurship',
      description: 'Provides loans up to ₹10 lakh to non-corporate, non-farm small/micro enterprises for income generating activities in manufacturing, trading and services sectors.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: null,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['Self-employed', 'Small Business Owner', 'Entrepreneur'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 1000000,
        type: 'Business Loan',
        frequency: 'One-time',
        description: 'Collateral-free loans up to ₹10 lakh under three categories: Shishu (up to ₹50,000), Kishore (₹50,001 to ₹5 lakh), Tarun (₹5 lakh to ₹10 lakh)',
      ),
      applicationProcess: 'Apply through any bank, NBFC or MFI offering MUDRA loans',
      documentsRequired: [
        'Identity proof (Aadhaar/Voter ID/Passport)',
        'Address proof',
        'Business plan/project report',
        'Bank statement (last 6 months)',
        'Photographs',
      ],
      officialLink: 'https://www.mudra.org.in/',
      launchDate: DateTime(2015, 4, 8),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 6. National Scholarship Portal
    Scheme(
      schemeId: 'nsp-sc-2024',
      name: 'Post Matric Scholarship for SC Students',
      ministry: 'Ministry of Social Justice and Empowerment',
      category: 'Education',
      description: 'Financial assistance to SC students studying in classes 11th and 12th, and pursuing post-matriculation or post-secondary courses to enable them to complete their education.',
      eligibility: Eligibility(
        minAge: 16,
        maxAge: 35,
        incomeMax: '2.5 Lakh',
        categories: ['SC'],
        occupations: ['Student'],
        states: ['All States'],
        education: ['Class 11th', 'Class 12th', 'Graduation', 'Post-Graduation', 'ITI', 'Diploma'],
      ),
      benefits: Benefits(
        amount: 50000,
        type: 'Scholarship',
        frequency: 'Yearly',
        description: 'Maintenance allowance, book grant, and other educational expenses',
      ),
      applicationProcess: 'Apply online through National Scholarship Portal (NSP)',
      documentsRequired: [
        'Aadhaar Card',
        'Caste certificate (SC)',
        'Income certificate',
        'Bank account details',
        'Previous year marksheet',
        'Current year admission proof',
      ],
      officialLink: 'https://scholarships.gov.in/',
      launchDate: DateTime(2008, 1, 1),
      deadline: DateTime(2024, 12, 31),
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 7. PM Fasal Bima Yojana
    Scheme(
      schemeId: 'pmfby-2024',
      name: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
      ministry: 'Ministry of Agriculture and Farmers Welfare',
      category: 'Agriculture',
      description: 'Crop insurance scheme providing financial support to farmers suffering crop loss/damage arising out of unforeseen events.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: null,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['Farmer', 'Agricultural Worker'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 200000,
        type: 'Insurance',
        frequency: 'Per Crop Season',
        description: 'Comprehensive risk cover for crop losses due to natural calamities, pests & diseases',
      ),
      applicationProcess: 'Apply through banks, CSCs, or online through PMFBY portal',
      documentsRequired: [
        'Aadhaar Card',
        'Land records (Khata/Khatauni)',
        'Bank account details',
        'Sowing certificate',
      ],
      officialLink: 'https://pmfby.gov.in/',
      launchDate: DateTime(2016, 2, 18),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 8. Stand Up India
    Scheme(
      schemeId: 'standup-india-2024',
      name: 'Stand Up India Scheme',
      ministry: 'Ministry of Finance',
      category: 'Business & Entrepreneurship',
      description: 'Facilitates bank loans between ₹10 lakh and ₹1 crore to at least one SC/ST borrower and one woman borrower per bank branch for setting up greenfield enterprise.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: null,
        incomeMax: null,
        categories: ['SC', 'ST', 'Women'],
        occupations: ['Entrepreneur', 'Self-employed'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 10000000,
        type: 'Business Loan',
        frequency: 'One-time',
        description: 'Loans between ₹10 lakh to ₹1 crore for greenfield enterprises in manufacturing, services or trading sector',
      ),
      applicationProcess: 'Apply through scheduled commercial banks or visit Stand Up India portal',
      documentsRequired: [
        'Identity proof (Aadhaar)',
        'Caste certificate (for SC/ST)',
        'Gender certificate (for Women)',
        'Project report',
        'Address proof',
        'Bank statements',
      ],
      officialLink: 'https://www.standupmitra.in/',
      launchDate: DateTime(2016, 4, 5),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 9. Atal Pension Yojana
    Scheme(
      schemeId: 'apy-2024',
      name: 'Atal Pension Yojana (APY)',
      ministry: 'Ministry of Finance',
      category: 'Senior Citizens & Pension',
      description: 'Government-backed pension scheme for unorganised sector workers. Guaranteed minimum pension of ₹1,000 to ₹5,000 per month from the age of 60 years.',
      eligibility: Eligibility(
        minAge: 18,
        maxAge: 40,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['All'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: 5000,
        type: 'Pension',
        frequency: 'Monthly',
        description: 'Guaranteed pension ranging from ₹1,000 to ₹5,000 per month after 60 years of age',
      ),
      applicationProcess: 'Visit any bank where you have a savings account with Aadhaar and mobile number',
      documentsRequired: [
        'Aadhaar Card',
        'Mobile number',
        'Bank account details',
      ],
      officialLink: 'https://www.india.gov.in/spotlight/atal-pension-yojana',
      launchDate: DateTime(2015, 5, 9),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),

    // 10. Beti Bachao Beti Padhao
    Scheme(
      schemeId: 'bbbp-2024',
      name: 'Beti Bachao Beti Padhao (BBBP)',
      ministry: 'Ministry of Women and Child Development',
      category: 'Women & Child Development',
      description: 'A social campaign addressing the declining Child Sex Ratio and related issues of empowerment of women over a life-cycle continuum.',
      eligibility: Eligibility(
        minAge: 0,
        maxAge: 21,
        incomeMax: null,
        categories: ['General', 'OBC', 'SC', 'ST'],
        occupations: ['All'],
        states: ['All States'],
        education: [],
      ),
      benefits: Benefits(
        amount: null,
        type: 'Awareness & Education',
        frequency: null,
        description: 'Educational support, awareness campaigns, and gender sensitization programs',
      ),
      applicationProcess: 'Contact district administration or women and child development department',
      documentsRequired: [
        'Girl child birth certificate',
        'Parent/Guardian identity proof',
        'Address proof',
      ],
      officialLink: 'https://wcd.nic.in/bbbp-schemes',
      launchDate: DateTime(2015, 1, 22),
      deadline: null,
      source: 'Government of India',
      videoTutorialId: null,
    ),
  ];
}
