import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/pages/folder_teams/team_members_details.dart';

class TaskMembers extends StatefulWidget {
  final TaskDetails task;

  const TaskMembers({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskMembers> createState() => _TaskMembersState();
}

class _TaskMembersState extends State<TaskMembers> {
  ValueNotifier<List<Members>> taskMembersNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fetchTaskMembers();
  }

  @override
  void didUpdateWidget(covariant TaskMembers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task != widget.task) {
      fetchTaskMembers();
    }
  }

  Future<void> fetchTaskMembers() async {
    final fetchedMembers = await getTaskMembers(widget.task);
    if (fetchedMembers != null) {
      taskMembersNotifier.value = fetchedMembers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Members>>(
      valueListenable: taskMembersNotifier,
      builder: (context, taskMembers, child) {
        return taskMembers.isEmpty
            ? GestureDetector(
                onTap: () {},
                child: const Tooltip(
                  message: 'Add Your Member in Edit Task',
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
            : Center(
                child: Container(
                  width: 350,
                  height:
                      150, // Set a fixed height or use constraints as per your UI design
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskMembers.length,
                    itemBuilder: (context, index) {
                      final member = taskMembers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => TeamMemberDetails(
                                member: member,
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100, // Set a fixed width
                              height: 100, // Set a fixed height
                              child: member.photo != null &&
                                      member.photo!.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 90,
                                      backgroundImage:
                                          FileImage(File(member.photo!)),
                                    )
                                  : const CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'lib/assets/default_avatar_member.jpg',
                                      ),
                                    ),
                            ),
                            Text(
                              member.name, // Display member's name here
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
