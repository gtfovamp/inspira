import 'package:flutter/services.dart';

class NativeShareUtil {
  static const _channel = MethodChannel('native_share');

  static Future<void> shareImage(Uint8List imageBytes) async {
    try {
      await _channel.invokeMethod('shareImage', imageBytes);
    } on PlatformException catch (e) {
      print("Failed to share image: '${e.message}'.");
    }
  }
}
