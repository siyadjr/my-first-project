import 'package:flutter/material.dart';

ButtonStyle buttonStyle() {
  return TextButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 0, 109, 116),
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
