import 'package:flutter/material.dart';

class ApplicationFormPage extends StatelessWidget {
  final String schemeId;

  const ApplicationFormPage({super.key, required this.schemeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Scheme')),
      body: Center(child: Text('Application Form for $schemeId - To be implemented')),
    );
  }
}
