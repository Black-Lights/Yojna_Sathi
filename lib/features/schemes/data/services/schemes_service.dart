import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../models/scheme.dart';

class SchemesService {
  final FirebaseFirestore _firestore;

  SchemesService(this._firestore);

  Future<List<Scheme>> getAllSchemes() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .get();

      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get schemes: $e');
    }
  }

  Future<Scheme?> getScheme(String schemeId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.schemesCollection)
          .doc(schemeId)
          .get();

      if (doc.exists) {
        return Scheme.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get scheme: $e');
    }
  }

  Future<List<Scheme>> getSchemesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get schemes by category: $e');
    }
  }

  Future<List<Scheme>> getSchemesByState(String state) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .where('eligibility.states', arrayContains: state)
          .get();

      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get schemes by state: $e');
    }
  }

  Future<List<Scheme>> searchSchemes(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a basic implementation. Consider using Algolia or ElasticSearch for production
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .get();

      final schemes = snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
      
      return schemes.where((scheme) {
        final lowerQuery = query.toLowerCase();
        return scheme.name.toLowerCase().contains(lowerQuery) ||
            scheme.description.toLowerCase().contains(lowerQuery) ||
            scheme.category.toLowerCase().contains(lowerQuery) ||
            scheme.ministry.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search schemes: $e');
    }
  }

  Future<void> addScheme(Scheme scheme) async {
    try {
      await _firestore
          .collection(AppConstants.schemesCollection)
          .doc(scheme.schemeId)
          .set(scheme.toFirestore());
    } catch (e) {
      throw Exception('Failed to add scheme: $e');
    }
  }

  Future<void> updateScheme(Scheme scheme) async {
    try {
      await _firestore
          .collection(AppConstants.schemesCollection)
          .doc(scheme.schemeId)
          .update(scheme.toFirestore());
    } catch (e) {
      throw Exception('Failed to update scheme: $e');
    }
  }

  Future<void> deleteScheme(String schemeId) async {
    try {
      await _firestore
          .collection(AppConstants.schemesCollection)
          .doc(schemeId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete scheme: $e');
    }
  }

  Stream<List<Scheme>> schemesStream() {
    return _firestore
        .collection(AppConstants.schemesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    });
  }

  Future<List<Scheme>> getRecentSchemes({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .orderBy('launchDate', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get recent schemes: $e');
    }
  }

  /// Get all active schemes (not expired)
  Future<List<Scheme>> getActiveSchemes() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.schemesCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => Scheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get active schemes: $e');
    }
  }

  /// Bulk add multiple schemes (for seeding)
  Future<void> addMultipleSchemes(List<Scheme> schemes) async {
    try {
      final batch = _firestore.batch();

      for (final scheme in schemes) {
        final docRef = _firestore
            .collection(AppConstants.schemesCollection)
            .doc(scheme.schemeId);
        batch.set(docRef, scheme.toFirestore());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to add multiple schemes: $e');
    }
  }
}
