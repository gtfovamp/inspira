import '../../../home/data/models/image_model.dart';

abstract class ImageRemoteDataSource {
  Future<String> saveImage(String imageBase64, String userId);
  Future<void> updateImage(String imageId, String imageBase64, String userId);
  Future<ImageModel> getImage(String imageId, String userId);
}