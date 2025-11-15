import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tutorial extends Equatable {
  final String tutorialId;
  final String schemeId;
  final String title;
  final String language;
  final String videoUrl;
  final int duration;
  final List<TutorialStep> steps;
  final String? thumbnailUrl;

  const Tutorial({
    required this.tutorialId,
    required this.schemeId,
    required this.title,
    required this.language,
    required this.videoUrl,
    required this.duration,
    required this.steps,
    this.thumbnailUrl,
  });

  factory Tutorial.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final stepsList = data['steps'] as List<dynamic>? ?? [];

    return Tutorial(
      tutorialId: data['tutorialId'] as String,
      schemeId: data['schemeId'] as String,
      title: data['title'] as String,
      language: data['language'] as String,
      videoUrl: data['videoUrl'] as String,
      duration: data['duration'] as int,
      steps: stepsList
          .map((step) => TutorialStep(
                stepNumber: step['stepNumber'] as int,
                title: step['title'] as String,
                description: step['description'] as String,
                imageUrl: step['imageUrl'] as String?,
              ))
          .toList(),
      thumbnailUrl: data['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tutorialId': tutorialId,
      'schemeId': schemeId,
      'title': title,
      'language': language,
      'videoUrl': videoUrl,
      'duration': duration,
      'steps': steps
          .map((step) => {
                'stepNumber': step.stepNumber,
                'title': step.title,
                'description': step.description,
                'imageUrl': step.imageUrl,
              })
          .toList(),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  List<Object?> get props => [
        tutorialId,
        schemeId,
        title,
        language,
        videoUrl,
        duration,
        steps,
        thumbnailUrl,
      ];
}

class TutorialStep extends Equatable {
  final int stepNumber;
  final String title;
  final String description;
  final String? imageUrl;

  const TutorialStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [stepNumber, title, description, imageUrl];
}
