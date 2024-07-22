import 'package:hive_flutter/hive_flutter.dart';

part 'team_details_.g.dart';

@HiveType(typeId: 1)
class TeamDetails {
  @HiveField(0)
  String? teamName; // Make fields nullable
  @HiveField(1)
  String? teamAbout; // Make fields nullable
  @HiveField(2)
  String? teamPhoto; // Make fields nullable
  @HiveField(3)
  List<int>? memberIds = []; // Store member IDs
  @HiveField(4)
  List<int>? taskIds = [];
  @HiveField(5)
  int id;

  TeamDetails({
    required this.teamName,
    required this.teamAbout,
    required this.teamPhoto,
    required this.memberIds,
    required this.taskIds,
    required this.id
  });
}
