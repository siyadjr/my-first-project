import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/add_tasks.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/detail_task.dart';

typedef DeleteFunction = Future<void> Function();

class AllTeamTask extends StatefulWidget {
  final TeamDetails team;
  const AllTeamTask({super.key, required this.team});

  @override
  State<AllTeamTask> createState() => _AllTeamTaskState();
}

class _AllTeamTaskState extends State<AllTeamTask> {
  List<TaskDetails> teamTasks = [];

  @override
  void initState() {
    super.initState();
    _fetchAllTasks();
  }

  Future<void> _fetchAllTasks() async {
    List<TaskDetails> tasks = await getTeamTasks(widget.team);
    setState(() {
      teamTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Tasks for ${widget.team.teamName}'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, 1);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: teamTasks.isEmpty
            ? const Center(
                child: Text(
                  'No tasks available.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ValueListenableBuilder(
                valueListenable: taskNotifier,
                builder: (context, value, child) => ListView.builder(
                  itemCount: teamTasks.length,
                  itemBuilder: (context, index) {
                    TaskDetails task = teamTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: task.photo != null && task.photo!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage: FileImage(File(task.photo!)),
                                )
                              : const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('lib/assets/default_task.jpg'),
                                ),
                          title: Text(task.taskname),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 18,
                            ),
                            onPressed: () {
                              _confirmDelete(index, task);
                            },
                          ),
                          onTap: () async {
                            final updatedTask = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => DetailTask(
                                          task: task,
                                          team: widget.team,
                                          showEdit: true,
                                        )));
                            if (updatedTask != null) {
                              setState(() {
                                teamTasks[index] = updatedTask;
                              });
                              _fetchAllTasks();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => AddTasks(team: widget.team),
              ),
            );
            if (result == 1) {
              _fetchAllTasks();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int index, TaskDetails task) async {
    await confirmAndDelete(
      context,
      'Are you sure you want to delete this task?',
      () async {
        await deleteTeamTaskId(widget.team, task.id);
        await deleteTask(task);
        setState(() {
          teamTasks.removeAt(index);
        });
      },
    );
  }
}
