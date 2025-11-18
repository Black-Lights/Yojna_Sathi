import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/scheme_dataset.dart';
import '../../../schemes/data/services/schemes_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _seedSchemes(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seeding comprehensive schemes data (50+ schemes)...')),
      );
      
      final firestore = FirebaseFirestore.instance;
      final schemesService = SchemesService(firestore);
      
      await SchemeDataset.seedSchemes(schemesService);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Successfully seeded 50+ government schemes!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
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
            title: const Text('Seed Comprehensive Schemes'),
            subtitle: const Text('Upload 50+ government schemes to Firestore'),
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
}
