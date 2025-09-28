import 'package:equatable/equatable.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object?> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageSaveSuccess extends ImageState {
  final String imageId;

  const ImageSaveSuccess(this.imageId);

  @override
  List<Object> get props => [imageId];
}

class ImageLoadSuccess extends ImageState {
  final String imageBase64;

  const ImageLoadSuccess(this.imageBase64);

  @override
  List<Object> get props => [imageBase64];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}