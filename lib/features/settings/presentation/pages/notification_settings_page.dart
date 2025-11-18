import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/constants.dart';
import '../../../notifications/data/services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = sl<NotificationService>();
  
  bool _isLoading = true;
  bool _newSchemes = true;
  bool _applicationUpdates = true;
  bool _generalAnnouncements = true;
  bool _eligibilityAlerts = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('notificationSettings')) {
          final settings = data['notificationSettings'] as Map<String, dynamic>;
          setState(() {
            _newSchemes = settings['newSchemes'] ?? true;
            _applicationUpdates = settings['applicationUpdates'] ?? true;
            _generalAnnouncements = settings['generalAnnouncements'] ?? true;
            _eligibilityAlerts = settings['eligibilityAlerts'] ?? true;
            _isLoading = false;
          });
          return;
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set({
        'notificationSettings': {
          'newSchemes': _newSchemes,
          'applicationUpdates': _applicationUpdates,
          'generalAnnouncements': _generalAnnouncements,
          'eligibilityAlerts': _eligibilityAlerts,
        },
      }, SetOptions(merge: true));

      // Subscribe/unsubscribe from topics based on settings
      if (_newSchemes) {
        await _notificationService.subscribeToTopic('new_schemes');
      } else {
        await _notificationService.unsubscribeFromTopic('new_schemes');
      }

      if (_applicationUpdates) {
        await _notificationService.subscribeToTopic('application_updates');
      } else {
        await _notificationService.unsubscribeFromTopic('application_updates');
      }

      if (_generalAnnouncements) {
        await _notificationService.subscribeToTopic('announcements');
      } else {
        await _notificationService.unsubscribeFromTopic('announcements');
      }

      if (_eligibilityAlerts) {
        await _notificationService.subscribeToTopic('eligibility_alerts');
      } else {
        await _notificationService.unsubscribeFromTopic('eligibility_alerts');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification settings saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Choose what notifications you want to receive',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('New Schemes'),
                  subtitle: const Text('Get notified when new schemes are added'),
                  value: _newSchemes,
                  onChanged: (value) {
                    setState(() {
                      _newSchemes = value;
                    });
                    _saveSettings();
                  },
                  secondary: const Icon(Icons.new_releases, color: Colors.blue),
                ),
                SwitchListTile(
                  title: const Text('Application Updates'),
                  subtitle: const Text('Status changes on your applications'),
                  value: _applicationUpdates,
                  onChanged: (value) {
                    setState(() {
                      _applicationUpdates = value;
                    });
                    _saveSettings();
                  },
                  secondary: const Icon(Icons.update, color: Colors.green),
                ),
                SwitchListTile(
                  title: const Text('Eligibility Alerts'),
                  subtitle: const Text('Schemes you may be eligible for'),
                  value: _eligibilityAlerts,
                  onChanged: (value) {
                    setState(() {
                      _eligibilityAlerts = value;
                    });
                    _saveSettings();
                  },
                  secondary: const Icon(Icons.check_circle, color: Colors.orange),
                ),
                SwitchListTile(
                  title: const Text('General Announcements'),
                  subtitle: const Text('Important updates and news'),
                  value: _generalAnnouncements,
                  onChanged: (value) {
                    setState(() {
                      _generalAnnouncements = value;
                    });
                    _saveSettings();
                  },
                  secondary: const Icon(Icons.campaign, color: Colors.purple),
                ),
                const Divider(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'About Notifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You can customize which notifications you receive. Changes are saved automatically and applied immediately.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
