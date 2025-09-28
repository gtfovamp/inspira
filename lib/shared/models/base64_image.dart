import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Uint8List decodeBase64(String base64String) {
  return base64Decode(base64String);
}

Widget buildBase64Image(String base64String) {
  return Image.memory(
    decodeBase64(base64String),
    fit: BoxFit.cover,
    gaplessPlayback: true,
  );
}
