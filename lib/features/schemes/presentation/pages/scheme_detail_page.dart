import 'package:flutter/material.dart';

class SchemeDetailPage extends StatelessWidget {
  final String schemeId;

  const SchemeDetailPage({super.key, required this.schemeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheme Details')),
      body: Center(child: Text('Scheme Details for $schemeId - To be implemented')),
    );
  }
}
