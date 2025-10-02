import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/services/notification_service.dart';
import '../../domain/usecases/image_usecases.dart';
import 'image_event.dart';
import 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final SaveImageUseCase saveImageUseCase;
  final GetImageUseCase getImageUseCase;
  final NotificationService notificationService;

  ImageBloc({
    required this.saveImageUseCase,
    required this.getImageUseCase,
    required this.notificationService,
  }) : super(ImageInitial()) {
    on<SaveImageEvent>(_onSaveImage);
    on<LoadImageEvent>(_onLoadImage);
  }

  Future<void> _onSaveImage(
    SaveImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    emit(ImageLoading());

    final base64String = base64Encode(event.imageData);

    final params = SaveImageParams(
      imageBase64: base64String,
      userId: event.userId,
      imageId: event.imageId,
    );

    final result = await saveImageUseCase(params);

    result.fold(
      (failure) async {
        emit(ImageError(failure.message));
        await notificationService.showImageSaveErrorNotification();
      },
      (imageId) async {
        emit(ImageSaveSuccess(imageId));
        await notificationService.showImageSavedNotification();
      },
    );
  }

  Future<void> _onLoadImage(
    LoadImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    emit(ImageLoading());

    final params = GetImageParams(imageId: event.imageId, userId: event.userId);

    final result = await getImageUseCase(params);

    result.fold(
      (failure) => emit(ImageError(failure.message)),
      (image) => emit(ImageLoadSuccess(image.image)),
    );
  }
}
