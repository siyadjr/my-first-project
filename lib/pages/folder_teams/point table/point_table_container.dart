import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/team_members_details.dart';

class PointTableContainer extends StatefulWidget {
  final TeamDetails team;
  final VoidCallback onRefresh;
  const PointTableContainer(
      {super.key, required this.team, required this.onRefresh});

  @override
  State<PointTableContainer> createState() => _PointTableContainerState();
}

class _PointTableContainerState extends State<PointTableContainer> {
  List<Members> members = [];

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<Members> fetchedMembers = await getTeamMember(widget.team);
    setState(() {
      members = fetchedMembers;
    });
  }

  @override
  void didUpdateWidget(covariant PointTableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.team != widget.team) {
      fetchMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    int length = members.length > 3 ? 3 : members.length;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      child: members.isEmpty
          ? const Center(
              child: Text('No members'),
            )
          : ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            TeamMemberDetails(member: member, index: index),
                      ),
                    );
                  },
                  title: Text(
                    member.name.toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: const Text('1'),
                  leading: member.photo != null && member.photo!.isNotEmpty
                      ? CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              const Color.fromARGB(255, 67, 123, 132),
                          backgroundImage: FileImage(File(member.photo!)),
                        )
                      : const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              'lib/assets/default_avatar_member.jpg'),
                        ),
                );
              },
            ),
    );
  }
}
