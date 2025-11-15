import 'package:flutter/material.dart';

class TutorialPlayerPage extends StatelessWidget {
  final String tutorialId;

  const TutorialPlayerPage({super.key, required this.tutorialId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: Center(child: Text('Tutorial Player for $tutorialId - To be implemented')),
    );
  }
}
