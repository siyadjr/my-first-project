// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/db/model/functins/members_db.dart';

class PointTableContainer extends StatefulWidget {
  final TeamDetails team;
  final VoidCallback onRefresh;

  const PointTableContainer({
    super.key,
    required this.team,
    required this.onRefresh,
  });

  @override
  _PointTableContainerState createState() => _PointTableContainerState();
}

class _PointTableContainerState extends State<PointTableContainer> {
  List<Members>? members;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Widget _buildAvatar(Members member) {
    if (member.photo != null && member.photo!.isNotEmpty) {
      File file = File(member.photo!);
      if (file.existsSync()) {
        return CircleAvatar(
          radius: 30,
          backgroundImage: FileImage(file),
        );
      }
    }

    return const CircleAvatar(
      radius: 30,
      backgroundImage: AssetImage('lib/assets/default_avatar_member.jpg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.getColor(AppColor.maincolor),
        appBar: AppBar(
          title: const Text('Point Table'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: resetListByPoints,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: members == null || members!.isEmpty
              ? Center(
                  child: Text(
                    'No Members',
                    style: TextStyle(
                        color: AppColors.getColor(AppColor.secondaryColor)),
                  ),
                )
              : ListView.builder(
                  itemCount: members!.length,
                  itemBuilder: (context, index) {
                    final member = members![index];
                    return ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                            color: AppColors.getColor(AppColor.secondaryColor)),
                      ), // Rank
                      title: Card(
                        child: ListTile(
                          leading: _buildAvatar(member),
                          title: Text(member.name),
                          subtitle: Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                '${member.pointsMap[widget.team.id] ?? 0} Points',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _incrementPoints(member),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _decrementPoints(member),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> fetchMembers() async {
    List<Members> fetchedMembers = await getTeamMember(widget.team.id);
    setState(() {
      members = fetchedMembers;
      _sortMembersByPoints();
    });
  }

  void resetListByPoints() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text(
              'Are you sure you want to reset all points? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performReset(); // Perform the reset operation
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _performReset() {
    setState(() {
      if (members != null) {
        for (var member in members!) {
          member.pointsMap[widget.team.id] = 0;
          updateMember(member); // Update member in DB
        }
        _sortMembersByPoints();
      }
    });
  }

  void _incrementPoints(Members member) {
    setState(() {
      member.pointsMap[widget.team.id] =
          (member.pointsMap[widget.team.id] ?? 0) + 1;
      updateMember(member); // Update member in DB
      _sortMembersByPoints();
    });
  }

  void _decrementPoints(Members member) {
    setState(() {
      if (member.pointsMap[widget.team.id] != null &&
          member.pointsMap[widget.team.id]! > 0) {
        member.pointsMap[widget.team.id] =
            member.pointsMap[widget.team.id]! - 1;
        updateMember(member);
        _sortMembersByPoints();
      }
    });
  }

  void _sortMembersByPoints() {
    members!.sort((a, b) => (b.pointsMap[widget.team.id] ?? 0)
        .compareTo(a.pointsMap[widget.team.id] ?? 0));
  }
}
