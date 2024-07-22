import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/edit_task.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/task_members.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/task_name_container.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/task_properties.dart';

class DetailTask extends StatefulWidget {
  final TaskDetails task;
  final TeamDetails team;
  final bool showEdit;

  const DetailTask({
    super.key,
    required this.task,
    required this.team,
    required this.showEdit,
  });

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  late TaskDetails _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    DateTime? taskDate;

    try {
      taskDate = DateTime.parse(_task.date);
    } catch (e) {
      taskDate = null; // Handle invalid date format
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _task);
            },
          ),
          actions: [
            if (widget.showEdit)
              IconButton(
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EditTask(
                        task: _task,
                        team: widget.team,
                      ),
                    ),
                  );
                  if (newTask != null) {
                    setState(() {
                      _task = newTask;
                    });
                  }
                },
                icon: const Icon(Icons.edit),
              ),
          ],
          iconTheme: IconThemeData(
            color: AppColors.getColor(AppColor.secondaryColor),
          ),
          backgroundColor: Colors.blue,
          title: Text(
            _task.taskname.toUpperCase(),
            style: TextStyle(
              color: AppColors.getColor(AppColor.secondaryColor),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskNameContainer(task: _task),
                const SizedBox(height: 20),
                TaskMembers(task: _task),
                const SizedBox(height: 20),
                TaskProperties(
                  textName: 'Task Name',
                  textValue: _task.taskname.toUpperCase(),
                ),
                const SizedBox(height: 10),
                if (taskDate != null)
                  TaskProperties(
                    textName: 'End Date',
                    textValue: formatter.format(taskDate),
                  )
                else
                  const TaskProperties(
                    textName: 'End Date',
                    textValue: 'Invalid date',
                  ),
                const SizedBox(height: 10),
                TaskProperties(
                  textName: 'Task Description',
                  textValue: _task.taskDescription,
                ),
                const SizedBox(height: 10),
                TaskProperties(
                  textName: 'Task Members',
                  textValue: _task.selectedMemberIds.length.toString(),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmDelete(_task);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          Text('Delete Task'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(TaskDetails task) async {
    await confirmAndDelete(
      context,
      'Are you sure you want to delete this task?',
      () async {
        deleteTeamTaskId(widget.team, task.id);
        deleteTask(task);
        Navigator.pop(context, 1);
      },
    );
  }
}
