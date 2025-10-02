import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            customIcon: SvgPicture.asset(
              'assets/icons/save_icon.svg',
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onTap: () => _handleShare(context),
            tooltip: 'Поделиться',
          ),
          _ToolButton(
            icon: Icons.photo_outlined,
            onTap: () => _handleImportImage(context),
            tooltip: 'Импорт изображения',
          ),
          _ToolButton(
            icon: CupertinoIcons.pen,
            onTap: () => _showBrushSizeDialog(context),
            tooltip: 'Размер кисти',
            badge: brushSize.toInt().toString(),
          ),
          _ToolButton(
            customIcon: SvgPicture.asset(
              'assets/icons/erase_icon.svg',
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
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
    if (currentImage == null) {
      if (context.mounted) {
        _showSnackBar(context, 'Нет изображения для экспорта', isError: true);
      }
      return;
    }

    try {
      final file = XFile.fromData(
        currentImage!,
        mimeType: 'image/png',
        name: 'drawing_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: 'Check out this drawing!',
          subject: 'My drawing',
          title: 'Drawing export',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Ошибка при экспорте: $e', isError: true);
      }
    }
  }

  Future<void> _handleImportImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        onImportImage?.call(bytes);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Ошибка при загрузке изображения: $e', isError: true);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBrushSizeDialog(BuildContext context) {
    double tempBrushSize = brushSize;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  color: Colors.white.withValues(alpha: 0.1),
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
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF604490),
                  inactiveTrackColor: const Color(0xFF604490).withValues(alpha: 0.3),
                  thumbColor: const Color(0xFF604490),
                  overlayColor: const Color(0xFF604490).withValues(alpha: 0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: tempBrushSize,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  onChanged: (value) {
                    setDialogState(() {
                      tempBrushSize = value;
                    });
                  },
                ),
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
              style: GoogleFonts.roboto(
                color: const Color(0xFF604490),
                fontWeight: FontWeight.w600,
              ),
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
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5C5C5C),
                Color(0xFF999999),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 100,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 9,
                top: -14,
                child: Container(
                  width: 47,
                  height: 14,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF5C5C5C),
                        Color(0xFF999999),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
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
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onTap;
  final String tooltip;
  final String? badge;
  final Color? color;
  final bool isActive;

  const _ToolButton({
    this.icon,
    this.customIcon,
    required this.onTap,
    required this.tooltip,
    this.badge,
    this.color,
    this.isActive = false,
  }) : assert(icon != null || customIcon != null,
  'Either icon or customIcon must be provided');

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
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                customIcon ??
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

  static const List<Color> _baseColors = [
    Colors.grey,
    Color(0xFF3A87FD),
    Color(0xFF5E30EB),
    Color(0xFFBE38F3),
    Color(0xFFE63B7A),
    Color(0xFFFE6250),
    Color(0xFFFF8648),
    Color(0xFFFFB43F),
    Color(0xFFFECB3E),
    Color(0xFFFFF76B),
    Color(0xFFE4EF65),
    Color(0xFF96D35F),
  ];

  List<List<Color>> _generateColorPalette() {
    final palette = <List<Color>>[];

    for (int row = 0; row < 10; row++) {
      final colorRow = <Color>[];

      for (int col = 0; col < 12; col++) {
        final Color color;

        if (row == 0) {
          final intensity = 1.0 - (col / 11);
          color = Color.lerp(Colors.black, Colors.white, intensity)!;
        } else {
          final baseColor = _baseColors[col];
          final hslColor = HSLColor.fromColor(baseColor);

          final lightnessMultiplier = 1.0 - (row - 1) * 0.1;
          final saturationMultiplier = 0.3 + (row - 1) * 0.08;

          color = hslColor
              .withLightness((hslColor.lightness * lightnessMultiplier).clamp(0.0, 1.0))
              .withSaturation(saturationMultiplier.clamp(0.0, 1.0))
              .toColor();
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
                      width: 23,
                      height: 23,
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
    return (a.r - b.r).abs() < 0.02 &&
        (a.g - b.g).abs() < 0.02 &&
        (a.b - b.b).abs() < 0.02;
  }
}