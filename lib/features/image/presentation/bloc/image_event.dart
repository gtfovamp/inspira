import 'package:equatable/equatable.dart';
import 'dart:typed_data';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object?> get props => [];
}

class SaveImageEvent extends ImageEvent {
  final Uint8List imageData;
  final String? imageId;
  final String userId;

  const SaveImageEvent({
    required this.imageData,
    this.imageId,
    required this.userId,
  });

  @override
  List<Object?> get props => [imageData, imageId, userId];
}

class LoadImageEvent extends ImageEvent {
  final String imageId;
  final String userId;

  const LoadImageEvent({
    required this.imageId,
    required this.userId,
  });

  @override
  List<Object> get props => [imageId, userId];
}