import 'package:flutter/material.dart';

class ApplicationDetailPage extends StatelessWidget {
  final String applicationId;

  const ApplicationDetailPage({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Details')),
      body: Center(child: Text('Application Details for $applicationId - To be implemented')),
    );
  }
}
