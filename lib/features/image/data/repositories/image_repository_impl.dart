import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_remote_data_source.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource remoteDataSource;

  ImageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> saveImage(String imageBase64, String userId) async {
    try {
      final imageId = await remoteDataSource.saveImage(imageBase64, userId);
      return Right(imageId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateImage(String imageId, String imageBase64, String userId) async {
    try {
      await remoteDataSource.updateImage(imageId, imageBase64, userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, ImageEntity>> getImage(String imageId, String userId) async {
    try {
      final imageModel = await remoteDataSource.getImage(imageId, userId);
      return Right(imageModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}