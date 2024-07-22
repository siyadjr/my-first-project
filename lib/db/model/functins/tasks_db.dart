// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';

ValueNotifier<List<TaskDetails>> taskNotifier = ValueNotifier([]);
ValueNotifier<List<TaskDetails>> taskTeamNotifier = ValueNotifier([]);

Future<void> addTask(TaskDetails task, TeamDetails team) async {
  final taskBox = await Hive.openBox<TaskDetails>('task_db');
  await taskBox.add(task);

  await addTaskToTeam(team.id, task.id);

  taskNotifier.value = taskBox.values.toList();
  taskNotifier.notifyListeners();
}

Future<List<TaskDetails>> getAllTasks(String? search) async {
  final taskBox = await Hive.openBox<TaskDetails>('task_db');
  List<TaskDetails> allTasks = taskBox.values.toList();
  if (search != null && search.isNotEmpty) {
    allTasks = allTasks
        .where((task) =>
            task.taskname.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
  return allTasks;
}

Future<List<TaskDetails>> getTeamTasks(TeamDetails team) async {
  final taskBox = await Hive.openBox<TaskDetails>('task_db');
  final taskIds = team.taskIds;

  List<TaskDetails> tasks = [];

  if (taskBox.values.isNotEmpty && taskIds != null) {
    for (int id in taskIds) {
      try {
        final task = taskBox.values.firstWhere((task) => task.id == id);
        tasks.add(task);
      } catch (e) {
        // Handle case where no matching task is found
        print('Task with id $id not found in taskBox.');
      }
    }
  } else {
    // Handle cases where either taskBox is empty or taskIds is null
    print('taskBox is empty or taskIds is null.');
  }

  return tasks;
}

Future<void> deleteTask(TaskDetails task) async {
  final taskBox = await Hive.openBox<TaskDetails>('task_db');
  final index =
      taskBox.values.toList().indexWhere((tasks) => task.id == tasks.id);
  await taskBox.deleteAt(index);
  taskNotifier.value = taskBox.values.toList();
  taskNotifier.notifyListeners();
}

Future<List<Members>> getTaskMembers(TaskDetails task) async {
  final memberIds = task.selectedMemberIds;
  final memberBox = await Hive.openBox<Members>('members_db');
  List<Members> members = [];
  for (int id in memberIds!) {
    Members? member = memberBox.values.firstWhere(
      (member) => member.id == id,
    );
    if (member != null) {
      members.add(member);
    }
  }

  return members;
}

Future<void> editTask(TaskDetails newTask) async {
  final taskBox = await Hive.openBox<TaskDetails>('task_db');
  final index =
      taskBox.values.toList().indexWhere((tasks) => newTask.id == tasks.id);
  print(index);
  taskBox.putAt(index, newTask);
  taskNotifier.value = taskBox.values.toList();
  taskNotifier.notifyListeners();
}
