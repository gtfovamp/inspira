import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;
  final bool isEraser;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

class DrawingCanvas extends StatefulWidget {
  final Uint8List? backgroundImage;
  final double brushSize;
  final Color brushColor;
  final bool isEraserMode;
  final Function(Uint8List)? onImageChanged;

  const DrawingCanvas({
    super.key,
    this.backgroundImage,
    this.brushSize = 5.0,
    this.brushColor = Colors.black,
    this.isEraserMode = false,
    this.onImageChanged,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<List<DrawingPoint>> strokes = [];
  List<DrawingPoint> currentStroke = [];
  final GlobalKey _canvasKey = GlobalKey();
  ui.Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  @override
  void didUpdateWidget(DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.backgroundImage != oldWidget.backgroundImage) {
      _loadBackgroundImage();
    }
  }

  Future<void> _loadBackgroundImage() async {
    if (widget.backgroundImage != null) {
      final codec = await ui.instantiateImageCodec(widget.backgroundImage!);
      final frame = await codec.getNextFrame();
      setState(() {
        backgroundImage = frame.image;
      });
    } else {
      setState(() {
        backgroundImage = null;
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    final RenderBox renderBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    currentStroke = [
      DrawingPoint(
        offset: localPosition,
        color: widget.brushColor,
        strokeWidth: widget.brushSize,
        isEraser: widget.isEraserMode,
      ),
    ];
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      currentStroke.add(
        DrawingPoint(
          offset: localPosition,
          color: widget.brushColor,
          strokeWidth: widget.brushSize,
          isEraser: widget.isEraserMode,
        ),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (currentStroke.isNotEmpty) {
      setState(() {
        strokes.add(List.from(currentStroke));
        currentStroke.clear();
      });
      _captureCanvas();
    }
  }

  Future<void> _captureCanvas() async {
    try {
      final RenderRepaintBoundary boundary =
      _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        widget.onImageChanged?.call(byteData.buffer.asUint8List());
      }
    } catch (e) {
      print('Error capturing canvas: $e');
    }
  }

  void clearCanvas() {
    setState(() {
      strokes.clear();
      currentStroke.clear();
    });
    _captureCanvas();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 333,
        height: 508,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: RepaintBoundary(
            key: _canvasKey,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: DrawingPainter(
                  backgroundImage: backgroundImage,
                  strokes: strokes,
                  currentStroke: currentStroke,
                ),
                size: const Size(333, 508),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final List<List<DrawingPoint>> strokes;
  final List<DrawingPoint> currentStroke;

  DrawingPainter({
    this.backgroundImage,
    required this.strokes,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (backgroundImage != null) {
      canvas.drawImageRect(
        backgroundImage!,
        Rect.fromLTWH(0, 0, backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble()),
        rect,
        Paint(),
      );
    } else {
      canvas.drawRect(rect, Paint()..color = Colors.white);
    }

    for (final stroke in [...strokes, currentStroke]) {
      if (stroke.isEmpty) continue;

      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.first.isEraser) {
        paint.blendMode = BlendMode.clear;
        paint.strokeWidth = stroke.first.strokeWidth;
      } else {
        paint.color = stroke.first.color;
        paint.strokeWidth = stroke.first.strokeWidth;
      }

      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first.offset, stroke.first.strokeWidth / 2, paint);
      } else {
        final path = Path();
        path.moveTo(stroke.first.offset.dx, stroke.first.offset.dy);

        for (int i = 1; i < stroke.length; i++) {
          path.lineTo(stroke[i].offset.dx, stroke[i].offset.dy);
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}