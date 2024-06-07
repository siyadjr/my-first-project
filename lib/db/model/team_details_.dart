import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/member_details.dart';

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
  List<Members>? members = [];

  TeamDetails({
    required this.teamName,
    required this.teamAbout,
    required this.teamPhoto,
    required this.members
  });
}
