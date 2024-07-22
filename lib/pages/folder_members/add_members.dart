import 'dart:io';

import 'package:flutter/material.dart';

import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/add_member_container.dart';

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
              AddMemberContainer(
                selectedImage: _selectedImage,
                onImageSelected: _setImage,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormFieldPage(
                        controllerType: nameController,
                        labelText: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        controllerType: roleController,
                        labelText: 'Role',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter role';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        controllerType: phoneController,
                        type: TextInputType.phone,
                        labelText: 'Phone',
                        maxlength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter Number only';
                          }
                          if (value.length < 10) {
                            return 'Please enter 10 numbers';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        controllerType: strengthController,
                        labelText: 'Strength',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter strength';
                          }
                          return null;
                        },
                      ),
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

  void _setImage(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _saveMemberDetails() async {
    final int memberId = DateTime.now().millisecondsSinceEpoch;
    final memberDetails = Members(
        name: nameController.text,
        role: roleController.text,
        phone: phoneController.text,
        strength: strengthController.text,
        photo: _selectedImage?.path,
        id: memberId,
        pointsMap: {});
    await addMembers(memberDetails);

    Navigator.pop(context);
  }
}
