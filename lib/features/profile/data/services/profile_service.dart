import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore;

  ProfileService(this._firestore);

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.userId)
          .set(profile.toFirestore());
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      final updatedProfile = profile.copyWith(
        lastUpdated: DateTime.now(),
      );
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(profile.userId)
          .update(updatedProfile.toFirestore());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  Stream<UserProfile?> profileStream(String userId) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    });
  }
}
