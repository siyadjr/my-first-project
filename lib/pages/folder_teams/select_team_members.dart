import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';

class SelectTeamMembers extends StatefulWidget {
  final TeamDetails team;

  const SelectTeamMembers({Key? key, required this.team}) : super(key: key);

  @override
  State<SelectTeamMembers> createState() => _SelectTeamMembersState();
}

class _SelectTeamMembersState extends State<SelectTeamMembers> {
  List<int> selectedMembers = [];
  List<Members> members = [];

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<Members> fetchedMembers = await getTeamMember(widget.team.id);

    setState(() {
      members = fetchedMembers;
    });
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
            'Select Team Members',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: members.isEmpty
            ? const Center(child: Text("No members"))
            : ListView.separated(
                itemCount: members.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    onTap: () {
                      _toggleSelection(member.id);
                    },
                    leading: member.photo != null && member.photo!.isNotEmpty
                        ? CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color.fromARGB(255, 67, 123, 132),
                            backgroundImage: FileImage(File(member.photo!)),
                          )
                        : const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                                'lib/assets/default_avatar_member.jpg'),
                          ),
                    title: Text(
                      member.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(member.role.toUpperCase()),
                    trailing: Checkbox(
                      value: selectedMembers.contains(member.id),
                      onChanged: (value) {
                        _toggleSelection(member.id);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _toggleSelection(int memberId) {
    setState(() {
      if (selectedMembers.contains(memberId)) {
        selectedMembers.remove(memberId);
      } else {
        selectedMembers.add(memberId);
      }
    });
  }
}
