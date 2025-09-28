import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/image_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ImageModel>> getImages();
  Future<void> deleteImage(String imageId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  HomeRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<List<ImageModel>> getImages() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      final querySnapshot = await firestore
          .collection('images')
          .doc(user.uid)
          .collection('user_images')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ImageModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteImage(String imageId) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('User not authenticated');
      }

      await firestore
          .collection('images')
          .doc(user.uid)
          .collection('user_images')
          .doc(imageId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}