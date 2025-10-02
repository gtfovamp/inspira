import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/image_model.dart';
import '../../domain/repositories/image_remote_data_source.dart';

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ImageRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference _getUserImagesCollection(String userId) {
    return firestore
        .collection('images')
        .doc(userId)
        .collection('user_images');
  }

  @override
  Future<String> saveImage(String imageBase64, String userId) async {
    if (imageBase64.isEmpty) {
      throw ServerException('Image data is empty');
    }

    try {
      final now = DateTime.now();
      final docId = '${userId}_${now.millisecondsSinceEpoch}';

      final imageModel = ImageModel(
        id: docId,
        image: imageBase64,
        createdAt: now,
      );

      await _getUserImagesCollection(userId)
          .doc(docId)
          .set(imageModel.toFirestore());

      return docId;
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error while saving image: ${e.message}');
    } catch (e) {
      throw ServerException('Failed to save image: $e');
    }
  }

  @override
  Future<void> updateImage(String imageId, String imageBase64, String userId) async {
    if (imageBase64.isEmpty) {
      throw ServerException('Image data is empty');
    }

    if (imageId.isEmpty) {
      throw ServerException('Image ID is empty');
    }

    try {
      final docRef = _getUserImagesCollection(userId).doc(imageId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw ServerException('Image not found');
      }

      final updateData = {
        'image': imageBase64,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await docRef.update(updateData);
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error while updating image: ${e.message}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update image: $e');
    }
  }

  @override
  Future<ImageModel> getImage(String imageId, String userId) async {
    if (imageId.isEmpty) {
      throw ServerException('Image ID is empty');
    }

    try {
      final doc = await _getUserImagesCollection(userId)
          .doc(imageId)
          .get();

      if (!doc.exists) {
        throw ServerException('Image not found');
      }

      final data = doc.data();
      if (data == null || data is! Map<String, dynamic>) {
        throw ServerException('Invalid image data format');
      }

      return ImageModel.fromFirestore(doc.id, data);
    } on FirebaseException catch (e) {
      throw ServerException('Firebase error while getting image: ${e.message}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get image: $e');
    }
  }
}