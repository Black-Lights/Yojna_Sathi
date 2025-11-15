import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../models/tutorial.dart';

class TutorialsService {
  final FirebaseFirestore _firestore;

  TutorialsService(this._firestore);

  Future<List<Tutorial>> getAllTutorials() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.tutorialsCollection)
          .get();

      return snapshot.docs.map((doc) => Tutorial.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get tutorials: $e');
    }
  }

  Future<Tutorial?> getTutorial(String tutorialId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.tutorialsCollection)
          .doc(tutorialId)
          .get();

      if (doc.exists) {
        return Tutorial.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get tutorial: $e');
    }
  }

  Future<List<Tutorial>> getTutorialsForScheme(String schemeId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.tutorialsCollection)
          .where('schemeId', isEqualTo: schemeId)
          .get();

      return snapshot.docs.map((doc) => Tutorial.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get tutorials for scheme: $e');
    }
  }

  Future<List<Tutorial>> getTutorialsByLanguage(String language) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.tutorialsCollection)
          .where('language', isEqualTo: language)
          .get();

      return snapshot.docs.map((doc) => Tutorial.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get tutorials by language: $e');
    }
  }

  Future<void> addTutorial(Tutorial tutorial) async {
    try {
      await _firestore
          .collection(AppConstants.tutorialsCollection)
          .doc(tutorial.tutorialId)
          .set(tutorial.toFirestore());
    } catch (e) {
      throw Exception('Failed to add tutorial: $e');
    }
  }

  Future<void> updateTutorial(Tutorial tutorial) async {
    try {
      await _firestore
          .collection(AppConstants.tutorialsCollection)
          .doc(tutorial.tutorialId)
          .update(tutorial.toFirestore());
    } catch (e) {
      throw Exception('Failed to update tutorial: $e');
    }
  }

  Future<void> deleteTutorial(String tutorialId) async {
    try {
      await _firestore
          .collection(AppConstants.tutorialsCollection)
          .doc(tutorialId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete tutorial: $e');
    }
  }

  Stream<Tutorial?> tutorialStream(String tutorialId) {
    return _firestore
        .collection(AppConstants.tutorialsCollection)
        .doc(tutorialId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Tutorial.fromFirestore(doc);
      }
      return null;
    });
  }
}
