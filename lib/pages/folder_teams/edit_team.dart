import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/select_members.dart';

class EditTeam extends StatefulWidget {
  final TeamDetails team;
  final int index;

  const EditTeam({super.key, required this.team, required this.index});

  @override
  State<EditTeam> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  late TextEditingController _nameController;
  late TextEditingController _aboutController;

  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<int> selectedMemberIds = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.teamName);
    _aboutController = TextEditingController(text: widget.team.teamAbout);
    selectedMemberIds = widget.team.memberIds!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Team'),
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
                            : widget.team.teamPhoto != null &&
                                    widget.team.teamPhoto!.isNotEmpty
                                ? FileImage(File(widget.team.teamPhoto!))
                                : const AssetImage(
                                        'lib/assets/team_default_image.jpg')
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
                        labelText: 'New team name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormFieldPage(
                        controllerType: _aboutController,
                        labelText: 'New about',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the about';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: ListTile(
                          title: const Text('Edit Your Members'),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_rounded),
                          onTap: () async {
                            final List<int>? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => SelectMembers(
                                  team: widget.team,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                selectedMemberIds = result;
                              });
                              
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveUpdated(widget.team, widget.index);
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

  Future<void> saveUpdated(TeamDetails team, int index) async {
    final updatedName = _nameController.text;
    final updatedAbout = _aboutController.text;

    final updatedImage =
        _selectedImage == null ? team.teamPhoto! : _selectedImage?.path;

    final newTeam = TeamDetails(
      teamName: updatedName,
      teamAbout: updatedAbout,
      teamPhoto: updatedImage,
      memberIds: selectedMemberIds,
    );

    await updatedTeam(newTeam, index);
    Navigator.pop(context, newTeam,);
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
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.photo_library),
              ),
              IconButton(
                onPressed: () {
                  _pickImageFromSource(ImageSource.camera);
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
}
