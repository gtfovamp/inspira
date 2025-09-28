import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/image_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ImageEntity>>> getImages();
  Future<Either<Failure, void>> deleteImage(String imageId);
}