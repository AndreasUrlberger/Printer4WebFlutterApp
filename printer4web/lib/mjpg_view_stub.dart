import 'package:flutter/material.dart';

Widget createMjpgView(String url) {
  return Image.network(
    url,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => const Center(
      child: Icon(Icons.videocam_off, color: Colors.white54),
    ),
  );
}
