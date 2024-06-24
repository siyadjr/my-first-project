import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/select_members.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({Key? key}) : super(key: key);

  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final teamNameController = TextEditingController();
  final teamAboutController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final List<int> selectedMemberIds = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF005d63),
          title: const Text(
            'Add Team',
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
                height: 250,
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
                      ),
                    ),
                  ],
                ),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldPage(
                        controllerType: teamNameController,
                        labelText: 'Team Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your team name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldPage(
                        controllerType: teamAboutController,
                        labelText: 'Team About',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your team about';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: ListTile(
                          title: const Text('Select Your Members'),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_rounded),
                          onTap: () async {
                            final List<int>? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const SelectMembers(),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                selectedMemberIds.clear();
                                selectedMemberIds.addAll(result);
                                
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveTeamDetails();
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
                  _pickImageFromSource(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_library),
              ),
              IconButton(
                onPressed: () {
                  _pickImageFromSource(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

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

  void _saveTeamDetails() async {
    final teamDetails = TeamDetails(
      teamName: teamNameController.text,
      teamAbout: teamAboutController.text,
      teamPhoto: _selectedImage?.path ?? '',
      memberIds: selectedMemberIds,
    );
    await addTeamData(teamDetails);
    teams.value.add(teamDetails);
    Navigator.pop(context);
  }
}
