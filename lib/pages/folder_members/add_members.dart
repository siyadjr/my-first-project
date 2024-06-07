import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final nameController = TextEditingController();
  final roleController = TextEditingController();
  final phoneController = TextEditingController();
  final strengthController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF005d63),
          title: const Text(
            'Add Member',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
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
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          label: const Text('Name'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter member name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: roleController,
                        decoration: InputDecoration(
                          label: const Text('Role'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          label: const Text('Phone number'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: strengthController,
                        decoration: InputDecoration(
                          label: const Text('Strength'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter strength';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveMemberDetails();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
        _selectedImage = File(pickedImage.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Image picking cancelled!')),
      ));
    }
  }

  void _saveMemberDetails() async {
    final memberDetails = Members(
      name: nameController.text,
      role: roleController.text,
      phone: phoneController.text,
      strength: strengthController.text,
      photo: _selectedImage?.path,
    );
    await addMembers(memberDetails);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
