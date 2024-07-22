import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMemberContainer extends StatefulWidget {
  final File? selectedImage;
  final void Function(File) onImageSelected; 
  
  const AddMemberContainer({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<AddMemberContainer> createState() => _AddMemberContainerState();
}

class _AddMemberContainerState extends State<AddMemberContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF005d63),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(60),
          bottomLeft: Radius.circular(60),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            backgroundImage:
                widget.selectedImage != null ? FileImage(widget.selectedImage!) : null,
            child: widget.selectedImage == null
                ? IconButton(
                    onPressed: () {
                      _showImagePicker(context);
                    },
                    icon: const Icon(Icons.add_a_photo_outlined),
                  )
                : null,
          ),
          TextButton(
            onPressed: () {
              _showImagePicker(context);
            },
            child: const Text(
              'Add Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _pickImageFromSource(1);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.photo_library),
              ),
              IconButton(
                onPressed: () {
                  _pickImageFromSource(0);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(int value) async {
    var pickedImage;
    if (value == 0) {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (pickedImage != null) {
      setState(() {
        widget.onImageSelected(File(pickedImage.path)); // Notify parent widget about the selected image
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Image picking cancelled!')),
      ));
    }
  }
}
