import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ToolPanelWidget extends StatelessWidget {
  final Uint8List? currentImage;
  final double brushSize;
  final Color brushColor;
  final bool isEraserMode;
  final Function(Uint8List?)? onImportImage;
  final Function(double)? onBrushSizeChanged;
  final Function(Color)? onColorChanged;
  final VoidCallback? onEraserToggle;

  const ToolPanelWidget({
    super.key,
    this.currentImage,
    this.brushSize = 5.0,
    this.brushColor = const Color(0xFFBE38F3),
    this.isEraserMode = false,
    this.onImportImage,
    this.onBrushSizeChanged,
    this.onColorChanged,
    this.onEraserToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ToolButton(
            icon: Icons.share,
            onTap: () => _handleShare(context),
            tooltip: 'Поделиться',
          ),
          _ToolButton(
            icon: Icons.image,
            onTap: () => _handleImportImage(context),
            tooltip: 'Импорт изображения',
          ),
          _ToolButton(
            icon: Icons.brush,
            onTap: () => _showBrushSizeDialog(context),
            tooltip: 'Размер кисти',
            badge: brushSize.toInt().toString(),
          ),
          _ToolButton(
            icon: Icons.auto_fix_high,
            onTap: onEraserToggle ?? () {},
            tooltip: isEraserMode ? 'Кисть' : 'Ластик',
            isActive: isEraserMode,
          ),
          _ToolButton(
            icon: Icons.palette,
            onTap: () => _showColorPicker(context),
            tooltip: 'Выбор цвета',
            color: brushColor,
          ),
        ],
      ),
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    if (currentImage != null) {
      try {
        await Share.shareXFiles([
          XFile.fromData(
            currentImage!,
            mimeType: 'image/png',
            name: 'drawing.png',
          ),
        ]);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при экспорте: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleImportImage(BuildContext context) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        onImportImage?.call(bytes);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при загрузке изображения: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showBrushSizeDialog(BuildContext context) {
    double tempBrushSize = brushSize;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          'Размер кисти',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Container(
                    width: tempBrushSize * 2,
                    height: tempBrushSize * 2,
                    decoration: BoxDecoration(
                      color: brushColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${tempBrushSize.toInt()} px',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: tempBrushSize,
                min: 1.0,
                max: 50.0,
                divisions: 49,
                activeColor: const Color(0xFF604490),
                inactiveColor: const Color(0xFF604490).withOpacity(0.3),
                onChanged: (value) {
                  setDialogState(() {
                    tempBrushSize = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: GoogleFonts.roboto(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              onBrushSizeChanged?.call(tempBrushSize);
              Navigator.pop(context);
            },
            child: Text(
              'Применить',
              style: GoogleFonts.roboto(color: const Color(0xFF604490)),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 343,
          height: 285,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF5C5C5C),
                const Color(0xFF999999).withOpacity(0.97),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 100,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 9,
                top: -13,
                child: Container(
                  width: 47,
                  height: 13,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF5C5C5C),
                        const Color(0xFF999999).withOpacity(0.97),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: _ColorGrid(
                  selectedColor: brushColor,
                  onColorSelected: (color) {
                    onColorChanged?.call(color);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final String? badge;
  final Color? color;
  final bool isActive;

  const _ToolButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.badge,
    this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
                if (badge != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: iconColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const _ColorGrid({
    required this.selectedColor,
    required this.onColorSelected,
  });

  List<List<Color>> _generateColorPalette() {
    final List<List<Color>> palette = [];

    final List<Color> baseColors = [
      Colors.grey,
      const Color(0xFF3A87FD),
      const Color(0xFF5E30EB),
      const Color(0xFFBE38F3),
      const Color(0xFFE63B7A),
      const Color(0xFFFE6250),
      const Color(0xFFFF8648),
      const Color(0xFFFFB43F),
      const Color(0xFFFECB3E),
      const Color(0xFFFFF76B),
      const Color(0xFFE4EF65),
      const Color(0xFF96D35F),
    ];

    for (int row = 0; row < 10; row++) {
      final List<Color> colorRow = [];

      for (int col = 0; col < 12; col++) {
        Color color;

        if (row == 0) {
          final double intensity = 1.0 - (col / 11);
          color = Color.lerp(Colors.black, Colors.white, intensity)!;
        } else {
          final baseColor = baseColors[col];
          final HSLColor hslColor = HSLColor.fromColor(baseColor);

          final double lightnessMultiplier = 1.0 - (row - 1) * 0.1;
          final double saturationMultiplier = 0.3 + (row - 1) * 0.08;

          color = hslColor.withLightness(
              (hslColor.lightness * lightnessMultiplier).clamp(0.0, 1.0)
          ).withSaturation(
              (saturationMultiplier).clamp(0.0, 1.0)
          ).toColor();
        }

        colorRow.add(color);
      }
      palette.add(colorRow);
    }

    return palette;
  }

  @override
  Widget build(BuildContext context) {
    final palette = _generateColorPalette();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: palette.map((row) =>
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row.map((color) =>
                  GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: color,
                        border: _colorsEqual(selectedColor, color)
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                    ),
                  ),
              ).toList(),
            ),
          ),
      ).toList(),
    );
  }

  bool _colorsEqual(Color a, Color b) {
    return (a.red - b.red).abs() < 5 &&
        (a.green - b.green).abs() < 5 &&
        (a.blue - b.blue).abs() < 5;
  }
}