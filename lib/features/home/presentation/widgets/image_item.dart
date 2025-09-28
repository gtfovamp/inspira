import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../domain/entities/image_entity.dart';

class ImageItem extends StatelessWidget {
  final ImageEntity image;
  final bool isLoaded;
  final AnimationController shimmerController;
  final VoidCallback onTap;

  const ImageItem({
    super.key,
    required this.image,
    required this.isLoaded,
    required this.shimmerController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: isLoaded ? _buildLoadedImage() : _buildShimmerLoader(),
    );
  }

  Widget _buildLoadedImage() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        key: ValueKey('loaded_${image.id}'),
        width: 156,
        height: 156,
        decoration: BoxDecoration(
          color: const Color(0xFF101010).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildBase64Image(image.image),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Container(
      key: const ValueKey('shimmer'),
      width: 156,
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8924E7).withOpacity(0.1),
            const Color(0xFF6A46F9).withOpacity(0.15),
            const Color(0xFF8924E7).withOpacity(0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: shimmerController,
        builder: (context, child) {
          final shimmerValue = Tween<double>(begin: -1.0, end: 2.0)
              .animate(CurvedAnimation(
            parent: shimmerController,
            curve: Curves.easeInOut,
          ))
              .value;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment(shimmerValue - 1, 0),
                end: Alignment(shimmerValue, 0),
                colors: [
                  Colors.transparent,
                  const Color(0xFF8924E7).withOpacity(0.3),
                  const Color(0xFF6A46F9).withOpacity(0.4),
                  const Color(0xFF8924E7).withOpacity(0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFFFFFFFF).withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBase64Image(String base64Data) {
    try {
      final cleanBase64 = base64Data.replaceAll(
        RegExp(r'^data:image\/[a-zA-Z]*;base64,'),
        '',
      );
      final Uint8List imageBytes = base64Decode(cleanBase64);
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        width: 156,
        height: 156,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 156,
            height: 156,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 40,
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        width: 156,
        height: 156,
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
      );
    }
  }
}