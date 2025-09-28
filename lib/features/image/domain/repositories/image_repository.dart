import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> saveImage(String imageBase64, String userId);
  Future<Either<Failure, void>> updateImage(String imageId, String imageBase64, String userId);
  Future<Either<Failure, ImageEntity>> getImage(String imageId, String userId);
}