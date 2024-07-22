import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/members_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/team_members_details.dart';

class TeamMembers extends StatefulWidget {
  final TeamDetails team;
  final VoidCallback onRefresh;

  const TeamMembers({Key? key, required this.team, required this.onRefresh})
      : super(key: key);

  @override
  State<TeamMembers> createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  ValueNotifier<List<Members>> membersNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    List<Members> fetchedMembers = await getTeamMember(widget.team.id);
    membersNotifier.value = fetchedMembers;
  }

  @override
  void didUpdateWidget(covariant TeamMembers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.team != widget.team) {
      fetchMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Members>>(
      valueListenable: membersNotifier,
      builder: (context, members, child) {
        int length = members.length > 3 ? 3 : members.length;

        return Container(
          height: members.length > 2 ? 200 : 120,
          padding: const EdgeInsets.all(8.0),
          child: members.isEmpty
              ? GestureDetector(
                  onTap: () {
                    // Handle adding members
                  },
                  child: const Tooltip(
                    message: 'Add Your member in EditTeam',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          'No members',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
      },
    );
  }
}
