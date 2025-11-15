import 'package:flutter/material.dart';

class SchemeListPage extends StatelessWidget {
  final String? category;
  final bool eligibleOnly;

  const SchemeListPage({super.key, this.category, this.eligibleOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category ?? 'All Schemes'),
      ),
      body: const Center(child: Text('Scheme List - To be implemented')),
    );
  }
}
