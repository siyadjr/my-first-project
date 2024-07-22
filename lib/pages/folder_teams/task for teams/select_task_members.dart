import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_members/add_members.dart';
import 'package:manager_app/pages/folder_members/member_details.dart';

class SelectTaskMembers extends StatefulWidget {
  final TaskDetails task;
  final TeamDetails team;
  const SelectTaskMembers({super.key, required this.task, required this.team});

  @override
  State<SelectTaskMembers> createState() => _SelectTaskMembersState();
}

class _SelectTaskMembersState extends State<SelectTaskMembers> {
  List<int> selectedMembers = [];
  List<Members> taskMembers = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final fetchTaskMembers = await getTeamMember(widget.team.id);
    if (fetchTaskMembers != null) {
      setState(() {
        taskMembers = fetchTaskMembers;
        _preSelectMembers(widget.task.selectedMemberIds);
      });
    }
  }

  void _preSelectMembers(List<int>? memberIds) {
    selectedMembers.clear();
    if (memberIds == null) return;
    for (var member in taskMembers) {
      if (memberIds.contains(member.id)) {
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
            'Select Task Members',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          centerTitle: true,
        ),
        body: taskMembers.isEmpty
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
            : ListView.builder(
                itemCount: taskMembers.length,
                itemBuilder: (context, index) {
                  final member = taskMembers[index];
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
                    leading: member.photo == null
                        ? const CircleAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/default_task.jpg'),
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
              ),
      ),
    );
  }
}
