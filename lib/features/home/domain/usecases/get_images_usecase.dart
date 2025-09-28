import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/image_entity.dart';
import '../repositories/home_repository.dart';

class GetImagesUseCase implements UseCase<List<ImageEntity>, NoParams> {
  final HomeRepository repository;

  GetImagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ImageEntity>>> call(NoParams params) async {
    return await repository.getImages();
  }
}