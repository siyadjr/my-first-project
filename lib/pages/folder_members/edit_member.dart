import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/all_members.dart';

class EditMembers extends StatefulWidget {
  final Members member;
  final int index;

  const EditMembers({super.key, required this.member, required this.index});

  @override
  State<EditMembers> createState() => _EditMembersState();
}

class _EditMembersState extends State<EditMembers> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;
  late TextEditingController _strengthController;
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _roleController = TextEditingController(text: widget.member.role);
    _phoneController = TextEditingController(text: widget.member.phone);
    _strengthController = TextEditingController(text: widget.member.strength);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Member'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : widget.member.photo != null &&
                                    widget.member.photo!.isNotEmpty
                                ? FileImage(File(widget.member.photo!))
                                : const AssetImage(
                                        'lib/assets/default_avatar_member.jpg')
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xFFCED9E3),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormFieldPage(
                        controllerType: _nameController,
                        labelText: 'New Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormFieldPage(
                        controllerType: _roleController,
                        labelText: 'New Role',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormFieldPage(
                        controllerType: _phoneController,
                        labelText: 'New Phone',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the phone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormFieldPage(
                        controllerType: _strengthController,
                        labelText: 'New Strength',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the strength';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveUpdated(widget.member, widget.index);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const AllMembers()));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUpdated(Members member, int index) async {
    final updatedName = _nameController.text;
    final updatedRole = _roleController.text;
    final updatedPhone = _phoneController.text;
    final updatedStrength = _strengthController.text;
    final updatedImage =
        _selectedImage == null ? member.photo! : _selectedImage?.path;

    final updatedMember = Members(
      name: updatedName,
      role: updatedRole,
      phone: updatedPhone,
      strength: updatedStrength,
      photo: updatedImage,
    );

    await updateMember(updatedMember, index);
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
    dynamic pickedImage;
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
}
