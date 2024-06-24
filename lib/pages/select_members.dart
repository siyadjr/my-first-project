import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_members/add_members.dart';
import 'package:manager_app/pages/folder_members/member_details.dart';

class SelectMembers extends StatefulWidget {
  final TeamDetails? team;

  const SelectMembers({Key? key, this.team}) : super(key: key);

  @override
  State<SelectMembers> createState() => _SelectMembersState();
}

class _SelectMembersState extends State<SelectMembers> {
  late Box<Members> memberBox = Hive.box<Members>('members_db');
  List<int> selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _getAllMembers();
  }

  Future<void> _getAllMembers() async {
    memberBox = await Hive.openBox<Members>('members_db');
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant SelectMembers oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.team != oldWidget.team) {
      selectedMembers.clear();
      if (widget.team != null) {
        _preSelectMembers(widget.team!.memberIds);
      }
    }
  }

  void _preSelectMembers(List<int>? memberIds) {
    selectedMembers.clear(); 
    if (memberIds == null) {
      return; 
    }
    for (int index = 0; index < memberBox.length; index++) {
      final member = memberBox.getAt(index);
      if (member != null && memberIds.contains(member.id)) {
        selectedMembers.add(member.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, selectedMembers);
              },
              icon: const Icon(Icons.file_download_done_sharp),
            ),
          ],
          title: const Text(
            'Select Your Members',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          centerTitle: true,
        ),
        body: memberBox.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text("No member"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const AddMembers(),
                          ),
                        );
                      },
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Add Members'),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ValueListenableBuilder(
                valueListenable: memberBox.listenable(),
                builder: (context, Box<Members> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(child: Text('No members found.'));
                  }

                  if (widget.team != null && selectedMembers.isEmpty) {
                    _preSelectMembers(widget.team!.memberIds);
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final member = box.getAt(index);
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DetailsMember(
                                member: member,
                                index: index,
                              ),
                            ),
                          );
                        },
                        leading: member!.photo == null
                            ? const CircleAvatar(
                                backgroundImage: AssetImage(
                                    'lib/assets/default_avatar_member.jpg'),
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(File(member.photo!)),
                              ),
                        title: Text(member.name),
                        subtitle: Text(member.role),
                        trailing: Checkbox(
                          value: selectedMembers.contains(member.id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  selectedMembers.add(member.id);
                                } else {
                                  selectedMembers.remove(member.id);
                                }
                              });
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
