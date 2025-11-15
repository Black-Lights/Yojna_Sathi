import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_scheme.dart';

class ApplicationsService {
  final FirebaseFirestore _firestore;
  final StorageService _storageService;

  ApplicationsService(this._firestore, this._storageService);

  Future<List<UserScheme>> getUserApplications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs.map((doc) => UserScheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get user applications: $e');
    }
  }

  Future<UserScheme?> getApplication(String recordId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .doc(recordId)
          .get();

      if (doc.exists) {
        return UserScheme.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get application: $e');
    }
  }

  Future<UserScheme?> getUserScheme(String userId, String schemeId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .where('userId', isEqualTo: userId)
          .where('schemeId', isEqualTo: schemeId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserScheme.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user scheme: $e');
    }
  }

  Future<void> createApplication(UserScheme userScheme) async {
    try {
      await _firestore
          .collection(AppConstants.userSchemesCollection)
          .doc(userScheme.recordId)
          .set(userScheme.toFirestore());
    } catch (e) {
      throw Exception('Failed to create application: $e');
    }
  }

  Future<void> updateApplication(UserScheme userScheme) async {
    try {
      final updated = userScheme.copyWith(lastUpdated: DateTime.now());
      
      await _firestore
          .collection(AppConstants.userSchemesCollection)
          .doc(userScheme.recordId)
          .update(updated.toFirestore());
    } catch (e) {
      throw Exception('Failed to update application: $e');
    }
  }

  Future<void> deleteApplication(String recordId) async {
    try {
      await _firestore
          .collection(AppConstants.userSchemesCollection)
          .doc(recordId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete application: $e');
    }
  }

  Future<List<UserScheme>> getEligibleSchemes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: AppConstants.statusEligible)
          .get();

      return snapshot.docs.map((doc) => UserScheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get eligible schemes: $e');
    }
  }

  Future<List<UserScheme>> getAppliedSchemes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: [
        AppConstants.statusApplied,
        AppConstants.statusPending,
        AppConstants.statusApproved,
      ]).get();

      return snapshot.docs.map((doc) => UserScheme.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get applied schemes: $e');
    }
  }

  Stream<UserScheme?> applicationStream(String recordId) {
    return _firestore
        .collection(AppConstants.userSchemesCollection)
        .doc(recordId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserScheme.fromFirestore(doc);
      }
      return null;
    });
  }

  Stream<List<UserScheme>> userApplicationsStream(String userId) {
    return _firestore
        .collection(AppConstants.userSchemesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserScheme.fromFirestore(doc)).toList();
    });
  }

  Future<int> getApplicationsCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.userSchemesCollection)
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: [
        AppConstants.statusApplied,
        AppConstants.statusPending,
      ]).get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get applications count: $e');
    }
  }
}
