import 'package:hive_flutter/hive_flutter.dart';
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
  Members(
      {required this.name,
      required this.role,
      required this.phone,
      required this.strength,
      required this.photo,
      required this.id});
}
