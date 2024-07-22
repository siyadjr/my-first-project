import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/button_style.dart';
import 'package:manager_app/db/model/functins/easy_access/guster_detector.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/all_task.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/detail_task.dart';

class TeamTaskContainer extends StatefulWidget {
  final TeamDetails team;
  final VoidCallback onRefresh;

  const TeamTaskContainer({
    super.key,
    required this.team,
    required this.onRefresh,
  });

  @override
  State<TeamTaskContainer> createState() => _TeamTaskContainerState();
}

class _TeamTaskContainerState extends State<TeamTaskContainer> {
  ValueNotifier<List<TaskDetails>> teamTasksNotifier = ValueNotifier([]);
  ValueNotifier<bool> showAllTaskButtonNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.team.taskIds!.isNotEmpty) {
      fetchAllTasks();
    }
  }

  Future<void> fetchAllTasks() async {
    List<TaskDetails> fetchedTasks = await getTeamTasks(widget.team);
    teamTasksNotifier.value = fetchedTasks;
    showAllTaskButtonNotifier.value = fetchedTasks.length > 3;
  }

  @override
  void didUpdateWidget(TeamTaskContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.team != widget.team) {
      fetchAllTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            final value = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AllTeamTask(team: widget.team)),
            );
            if (value != null) {
              fetchAllTasks();
            }
          },
          style: buttonStyle(),
          child: const Text(
            'All Task',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder<List<TaskDetails>>(
                  valueListenable: teamTasksNotifier,
                  builder: (context, teamTasks, child) {
                    int length = teamTasks.length > 3 ? 3 : teamTasks.length;

                    return teamTasks.isEmpty
                        ? const GusterDetector(
                            message: 'Add Your Task in All Task',
                            text: 'No task found',
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: length +
                                (showAllTaskButtonNotifier.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (showAllTaskButtonNotifier.value &&
                                  index == length) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      'All Tasks',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final value = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllTeamTask(team: widget.team),
                                          ),
                                        );
                                        if (value != null) {
                                          fetchAllTasks();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.arrow_right,
                                        color: Colors.blue,
                                      ),
                                    )
                                  ],
                                );
                              }

                              final task = teamTasks[index];
                              return GestureDetector(
                                onTap: () async {
                                  final value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => DetailTask(
                                        task: task,
                                        team: widget.team,
                                        showEdit: false,
                                      ),
                                    ),
                                  );
                                  if (value != null) {
                                    fetchAllTasks();
                                  }
                                },
                                child: Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: task.photo != null &&
                                                    task.photo!.isNotEmpty
                                                ? Image.file(
                                                    File(task.photo!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'lib/assets/default_task.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              task.taskname,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
