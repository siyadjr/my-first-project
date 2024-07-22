// member_details.dart

import 'package:hive/hive.dart';

part 'member_details.g.dart';

@HiveType(typeId: 3)
class Members {
  @HiveField(0)
  String name;

  @HiveField(1)
  String role;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String strength;

  @HiveField(4)
  String? photo;

  @HiveField(5)
  int id;

  @HiveField(6)
  Map<int, int> pointsMap; // Nullable Map

  Members({
    required this.name,
    required this.role,
    required this.phone,
    required this.strength,
    this.photo,
    required this.id,
   required this.pointsMap,
  });
}
