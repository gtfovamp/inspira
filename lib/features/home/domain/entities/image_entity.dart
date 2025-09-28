import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String image;
  final DateTime createdAt;

  const ImageEntity({
    required this.id,
    required this.image,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, image, createdAt];
}