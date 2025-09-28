import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/image_model.dart';

abstract class ImageRemoteDataSource {
  Future<String> saveImage(String imageBase64, String userId);
  Future<void> updateImage(String imageId, String imageBase64, String userId);
  Future<ImageModel> getImage(String imageId, String userId);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ImageRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<String> saveImage(String imageBase64, String userId) async {
    try {
      final now = DateTime.now();
      final docId = '${userId}_${now.millisecondsSinceEpoch}';

      final imageModel = ImageModel(
        id: docId,
        image: imageBase64,
        createdAt: now,
      );

      await firestore
          .collection('images')
          .doc(userId)
          .collection('user_images')
          .doc(docId)
          .set(imageModel.toFirestore());

      return docId;
    } catch (e) {
      throw ServerException('Failed to save image: $e');
    }
  }

  @override
  Future<void> updateImage(String imageId, String imageBase64, String userId) async {
    try {
      final updateData = {
        'image': imageBase64,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('images')
          .doc(userId)
          .collection('user_images')
          .doc(imageId)
          .update(updateData);
    } catch (e) {
      throw ServerException('Failed to update image: $e');
    }
  }

  @override
  Future<ImageModel> getImage(String imageId, String userId) async {
    try {
      final doc = await firestore
          .collection('images')
          .doc(userId)
          .collection('user_images')
          .doc(imageId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw ServerException('Image not found');
      }

      return ImageModel.fromFirestore(doc.id, doc.data()!);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get image: $e');
    }
  }
}