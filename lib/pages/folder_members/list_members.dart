import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/edit_member.dart';
import 'package:manager_app/pages/folder_members/member_details.dart';
import 'package:manager_app/pages/folder_members/search_members.dart';

typedef DeleteFunction = Future<void> Function();

class ListMembers extends StatefulWidget {
  const ListMembers({super.key});

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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(member.role.toUpperCase()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMembers(
                                        member: member,
                                        index: index,
                                      ),
                                    ),
                                  ).then((_) => _fetchAllMembers());
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                onPressed: () => _confirmDelete(index, member),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: members.length,
                    );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(int index, Members member) async {
    await confirmAndDelete(
      context,
      'Are you sure you want to delete this member?',
      () async {
        deleteMembers(index);
        deleteTeamMemberId(member.id);
        setState(() {});
      },
    );
  }
}
