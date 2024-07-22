import 'package:flutter/material.dart';

class GusterDetector extends StatefulWidget {
  final String message;
  final String text;
  const GusterDetector({super.key, required this.message,required this.text});

  @override
  State<GusterDetector> createState() => _GusterDetectorState();
}

class _GusterDetectorState extends State<GusterDetector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child:  Tooltip(
        message: widget.message,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, color: Colors.grey),
            SizedBox(width: 5),
            Text(
             widget.text,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
