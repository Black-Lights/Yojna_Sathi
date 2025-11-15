import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> uploadDocument({
    required String userId,
    required String schemeId,
    required File file,
    required String documentType,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'documents/$userId/$schemeId/${timestamp}_$fileName';

      final ref = _storage.ref().child(storagePath);
      final uploadTask = await ref.putFile(file);
      
      return storagePath;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  Future<void> deleteFile(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<String> uploadVideo({
    required String tutorialId,
    required File file,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final storagePath = 'videos/$tutorialId/$fileName';

      final ref = _storage.ref().child(storagePath);
      await ref.putFile(file);
      
      return storagePath;
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  Future<String> uploadImage({
    required String folder,
    required File file,
  }) async {
    try {
      final fileName = path.basename(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'images/$folder/${timestamp}_$fileName';

      final ref = _storage.ref().child(storagePath);
      await ref.putFile(file);
      
      return storagePath;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
