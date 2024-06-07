import 'package:hive/hive.dart';
part 'user_pass_name.g.dart';

@HiveType(typeId: 0)
class UserDetails extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String password;

  UserDetails({required this.name, required this.password});
}

