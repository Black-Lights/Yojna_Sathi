import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../schemes/data/models/scheme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _seedSchemes(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seeding schemes data...')),
      );
      
      final schemes = _getInitialSchemes();
      final firestore = FirebaseFirestore.instance;
      
      for (var scheme in schemes) {
        await firestore
            .collection('schemes')
            .doc(scheme.schemeId)
            .set(scheme.toFirestore());
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Seeded ${schemes.length} schemes successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Error seeding data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Development Tools Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Development Tools',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload, color: Colors.orange),
            title: const Text('Seed Schemes Data'),
            subtitle: const Text('Upload initial schemes to Firestore'),
            onTap: () => _seedSchemes(context),
          ),
          const Divider(),
          
          // Regular Settings
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'App Settings',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  List<Scheme> _getInitialSchemes() {
    return [
      // Sample schemes - for full list, use the scripts/seed_schemes.dart
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
    ];
  }
}
