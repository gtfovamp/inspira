import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/app_background.dart';
import '../bloc/image_bloc.dart';
import '../bloc/image_event.dart';
import '../bloc/image_state.dart';
import '../widgets/drawing_canvas_widget.dart';
import '../widgets/tool_panel_widget.dart';
import '../widgets/status_bar_widget.dart';

class ImagePage extends StatelessWidget {
  final Map<String, dynamic>? extra;

  const ImagePage({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final String? image = extra?['image'];
    final String? imageId = extra?['imageId'];

    return BlocProvider(
      create: (context) => sl<ImageBloc>(),
      child: ImageView(image: image, imageId: imageId),
    );
  }
}

class ImageView extends StatefulWidget {
  final String? image;
  final String? imageId;

  const ImageView({super.key, this.image, this.imageId});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Uint8List? myImageBytes;
  double brushSize = 5.0;
  Color brushColor = const Color(0xFFBE38F3);
  bool isEraserMode = false;

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  void _initializeImage() {
    if (widget.image != null) {
      try {
        myImageBytes = base64Decode(widget.image!);
      } catch (_) {
        myImageBytes = null;
      }
    } else if (widget.imageId != null) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        context.read<ImageBloc>().add(LoadImageEvent(
          imageId: widget.imageId!,
          userId: userId,
        ));
      }
    }
  }

  void _onImportImage(Uint8List? imageBytes) {
    if (imageBytes != null) {
      setState(() {
        myImageBytes = imageBytes;
      });
    }
  }

  void _onBrushSizeChanged(double size) {
    setState(() {
      brushSize = size;
      isEraserMode = false;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      brushColor = color;
      isEraserMode = false;
    });
  }

  void _onEraserToggle() {
    setState(() {
      isEraserMode = !isEraserMode;
    });
  }

  void _onImageChanged(Uint8List imageBytes) {
    setState(() {
      myImageBytes = imageBytes;
    });
  }

  void _handleSave() {
    if (myImageBytes == null) {
      context.pop(false);
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      context.pop(false);
      return;
    }

    context.read<ImageBloc>().add(SaveImageEvent(
      imageData: myImageBytes!,
      imageId: widget.imageId,
      userId: userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageSaveSuccess) {
          context.pop(true);
        } else if (state is ImageLoadSuccess) {
          try {
            setState(() {
              myImageBytes = base64Decode(state.imageBase64);
            });
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ошибка декодирования изображения'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is ImageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            AppBackground(),
            _buildMainContent(),
            BlocBuilder<ImageBloc, ImageState>(
              builder: (context, state) {
                if (state is ImageLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        StatusBarWidget(
          onBackPressed: () => context.pop(false),
          onSavePressed: _handleSave,
          title: 'Изображение',
        ),
        ToolPanelWidget(
          currentImage: myImageBytes,
          brushSize: brushSize,
          brushColor: brushColor,
          isEraserMode: isEraserMode,
          onImportImage: _onImportImage,
          onBrushSizeChanged: _onBrushSizeChanged,
          onColorChanged: _onColorChanged,
          onEraserToggle: _onEraserToggle,
        ),
        Expanded(
          child: DrawingCanvas(
            backgroundImage: myImageBytes,
            brushSize: brushSize,
            brushColor: brushColor,
            isEraserMode: isEraserMode,
            onImageChanged: _onImageChanged,
          ),
        ),
      ],
    );
  }
}