import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/image_entity.dart';
import '../repositories/image_repository.dart';

class SaveImageParams {
  final String imageBase64;
  final String userId;
  final String? imageId;

  const SaveImageParams({
    required this.imageBase64,
    required this.userId,
    this.imageId,
  });
}

class SaveImageUseCase implements UseCase<String, SaveImageParams> {
  final ImageRepository repository;

  SaveImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SaveImageParams params) {
    if (params.imageId != null && params.imageId!.isNotEmpty) {
      return repository.updateImage(params.imageId!, params.imageBase64, params.userId)
          .then((result) => result.fold(
            (failure) => Left(failure),
            (_) => Right(params.imageId!),
      ));
    } else {
      return repository.saveImage(params.imageBase64, params.userId);
    }
  }
}

class GetImageParams {
  final String imageId;
  final String userId;

  const GetImageParams({
    required this.imageId,
    required this.userId,
  });
}

class GetImageUseCase implements UseCase<ImageEntity, GetImageParams> {
  final ImageRepository repository;

  GetImageUseCase(this.repository);

  @override
  Future<Either<Failure, ImageEntity>> call(GetImageParams params) {
    return repository.getImage(params.imageId, params.userId);
  }
}