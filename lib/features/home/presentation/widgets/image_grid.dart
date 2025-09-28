import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/image_entity.dart';
import '../bloc/home_bloc.dart';
import 'image_item.dart';

class ImageGrid extends StatefulWidget {
  final List<ImageEntity> images;

  const ImageGrid({
    super.key,
    required this.images,
  });

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> with TickerProviderStateMixin {
  List<bool> loadedImages = [];
  late AnimationController _shimmerController;
  List<String> _previousImageIds = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initLoadedImages();
    _loadImagesSequentially();
  }

  @override
  void didUpdateWidget(ImageGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentImageIds = widget.images.map((img) => img.id).toList();

    if (!_listsEqual(currentImageIds, _previousImageIds)) {
      _previousImageIds = currentImageIds;
      _initLoadedImages();
      _loadImagesSequentially();
    }
  }

  bool _listsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void _initAnimations() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  void _initLoadedImages() {
    loadedImages = List.filled(widget.images.length, false);
    _previousImageIds = widget.images.map((img) => img.id).toList();
  }

  Future<void> _loadImagesSequentially() async {
    for (int i = 0; i < widget.images.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          if (i < loadedImages.length) {
            loadedImages[i] = true;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final isLoaded = index < loadedImages.length ? loadedImages[index] : false;

        return ImageItem(
          image: widget.images[index],
          isLoaded: isLoaded,
          shimmerController: _shimmerController,
          onTap: () => _onImageTap(context, index),
        );
      },
    );
  }

  Future<void> _onImageTap(BuildContext context, int index) async {
    final image = widget.images[index];

    await context.push<bool>('/image', extra: {
      'image': image.image,
      'imageId': image.id,
    });

    if (mounted) {
      context.read<HomeBloc>().add(RefreshImagesEvent());
    }
  }
}