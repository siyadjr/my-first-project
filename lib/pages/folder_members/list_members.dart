import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
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
              if (members.isEmpty) {
                return const Center(
                  child: Text('No members available'),
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => DetailsMember(
                                member: members[index], index: index)));
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
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 15,
                        ),
                        onPressed: () => confirmDelete(index),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: members.length,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> confirmDelete(int index) async {
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
