import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_members/add_members.dart';
import 'package:manager_app/pages/folder_members/member_details.dart';

class SelectMembers extends StatefulWidget {
  final TeamDetails? team;
  
  const SelectMembers({Key? key, this.team, required List<int> initialSelectedMembers}) : super(key: key);

  @override
  State<SelectMembers> createState() => _SelectMembersState();
}

class _SelectMembersState extends State<SelectMembers> {
  late Box<Members> memberBox;
  late ValueNotifier<List<int>> selectedMembersNotifier;

  @override
  void initState() {
    super.initState();
    memberBox = Hive.box<Members>('members_db');
    selectedMembersNotifier = ValueNotifier([]);
    _preSelectMembers(widget.team?.memberIds);
  }

  @override
  void didUpdateWidget(covariant SelectMembers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.team != oldWidget.team) {
      _preSelectMembers(widget.team?.memberIds);
    }
  }

  void _preSelectMembers(List<int>? memberIds) {
    if (memberIds == null) {
      selectedMembersNotifier.value = [];
      return;
    }
    List<int> selected = [];
    for (int index = 0; index < memberBox.length; index++) {
      final member = memberBox.getAt(index);
      if (member != null && memberIds.contains(member.id)) {
        selected.add(member.id);
      }
    }
    selectedMembersNotifier.value = selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context, selectedMembersNotifier.value);
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
        body: ValueListenableBuilder<List<int>>(
          valueListenable: selectedMembersNotifier,
          builder: (context, selectedMembers, _) {
            return memberBox.isEmpty
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
                    itemCount: memberBox.length,
                    itemBuilder: (context, index) {
                      final member = memberBox.getAt(index)!;
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
                            if(value!=null){
                              setState(() {
                              if (value) {
                                selectedMembersNotifier.value = [...selectedMembers, member.id];
                              } else {
                                selectedMembersNotifier.value = selectedMembers.where((id) => id != member.id).toList();
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
