import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import 'empty_gallery.dart';
import 'image_grid.dart';

class HomeGallery extends StatelessWidget {
  final HomeState state;

  const HomeGallery({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF8924E7)),
      );
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка: ${(state as HomeError).message}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(GetImagesEvent());
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      final images = (state as HomeLoaded).images;

      if (images.isEmpty) {
        return const EmptyGallery();
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(RefreshImagesEvent());
        },
        color: const Color(0xFF8924E7),
        child: ImageGrid(images: images),
      );
    }

    return const SizedBox.shrink();
  }
}