import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.image,
    required super.createdAt,
  });

  factory ImageModel.fromFirestore(String docId, Map<String, dynamic> data) {
    return ImageModel(
      id: docId,
      image: data['image'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ImageModel.fromEntity(ImageEntity entity) {
    return ImageModel(
      id: entity.id,
      image: entity.image,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'image': image,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toUpdateFirestore() {
    return {
      'image': image,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}