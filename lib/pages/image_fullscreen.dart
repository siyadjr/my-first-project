import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;

  const FullScreenImage({super.key, this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Hero(
              tag: heroTag,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.file(File(imageUrl!))
                  : Image.asset(
                      'lib/assets/default_avatar_member.jpg',
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
