import 'dart:convert';

import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final Future<String> base64Future;

  const Base64ImageWidget({super.key, required this.base64Future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: base64Future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        } else {
          final bytes = base64Decode(snapshot.data!);
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}
