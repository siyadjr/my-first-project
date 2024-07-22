import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/additional/select_members.dart';
import 'package:manager_app/pages/folder_teams/add_team_container.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({super.key});

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
              AddTeamContainer(
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
                        controllerType: teamNameController,
                        labelText: 'Team Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your team name';
                          }
                          return null;
                        },
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
                                builder: (ctx) => const SelectMembers(
                                  initialSelectedMembers: [],
                                ),
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

  void _setImage(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _saveTeamDetails() async {
    final int teamId = DateTime.now().millisecond;
    final teamDetails = TeamDetails(
        teamName: teamNameController.text,
        teamAbout: teamAboutController.text,
        teamPhoto: _selectedImage?.path ?? '',
        memberIds: selectedMemberIds,
        taskIds: [],
        id: teamId);
    await addTeamData(teamDetails);
    teams.value.add(teamDetails);
    Navigator.pop(context);
  }
}
