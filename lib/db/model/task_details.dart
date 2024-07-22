import 'package:hive_flutter/hive_flutter.dart';
part 'task_details.g.dart';

@HiveType(typeId: 5)
class TaskDetails {
  @HiveField(0)
  String taskname;
  @HiveField(1)
  String taskDescription;
  @HiveField(2)
  String date;
  @HiveField(3)
  int id;
  @HiveField(4)
  String? photo;
  @HiveField(5)
  List<int>selectedMemberIds=[];

  TaskDetails(
      {required this.taskname,
      required this.taskDescription,
      required this.date,
      required this.id,
      required this.photo,
      required this.selectedMemberIds});
}
