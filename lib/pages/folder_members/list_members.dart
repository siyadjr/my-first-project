import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/member_details.dart';
import 'package:manager_app/pages/folder_members/search_members.dart';

class ListMembers extends StatefulWidget {
  const ListMembers({Key? key}) : super(key: key);

  @override
  State<ListMembers> createState() => _ListMembersState();
}

class _ListMembersState extends State<ListMembers> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAllMembers();
  }

  Future<void> _fetchAllMembers() async {
    final members = await getAllMembers(_searchQuery);
    memberPass.value = members;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchMembers(
          onSearch: (query) {
            setState(() {
              _searchQuery = query;
            });
            _fetchAllMembers();
          },
        ),
        Flexible(
          child: ValueListenableBuilder<List<Members>>(
              valueListenable: memberPass,
              builder: (context, members, child) {
                return members.isEmpty
                    ? const Center(
                        child: Text("No members"),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return ListTile(
                            onTap: () async {
                              final value = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => DetailsMember(
                                          member: member, index: index)));
                              if (value != null) {
                                setState(() {
                                  _fetchAllMembers();
                                });
                              }
                            },
                            leading: member.photo != null &&
                                    member.photo!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        const Color.fromARGB(255, 67, 123, 132),
                                    backgroundImage:
                                        FileImage(File(member.photo!)),
                                  )
                                : const CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                        'lib/assets/default_avatar_member.jpg'),
                                  ),
                            title: Text(
                              member.name.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(member.role.toUpperCase()),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 15,
                              ),
                              onPressed: () => confirmDelete(index, member),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: members.length,
                      );
              }),
        ),
      ],
    );
  }

  Future<void> confirmDelete(int index, Members member) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete', style: TextStyle()),
            content: const Text('Are you sure you want to  delete?'),
            actions: [
              TextButton(
                onPressed: () {
                  deleteMembers(index);
                  deleteTeamMemberId(member.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }
}
