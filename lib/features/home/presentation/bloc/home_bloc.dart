import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/get_images_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetImagesUseCase getImagesUseCase;

  HomeBloc({required this.getImagesUseCase}) : super(HomeInitial()) {
    on<GetImagesEvent>(_onGetImages);
    on<RefreshImagesEvent>(_onRefreshImages);
  }

  Future<void> _onGetImages(GetImagesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final result = await getImagesUseCase(NoParams());

    result.fold(
          (failure) => emit(HomeError(failure.message)),
          (images) => emit(HomeLoaded(images)),
    );
  }

  Future<void> _onRefreshImages(RefreshImagesEvent event, Emitter<HomeState> emit) async {
    final result = await getImagesUseCase(NoParams());

    result.fold(
          (failure) => emit(HomeError(failure.message)),
          (images) => emit(HomeLoaded(images)),
    );
  }
}