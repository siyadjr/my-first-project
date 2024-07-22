import 'package:hive_flutter/hive_flutter.dart';
part 'event_model.g.dart';
@HiveType(typeId: 6)
class EventModel {
  @HiveField(0)
  String eventDescription;
  @HiveField(1)
  String date;
  @HiveField(2)
  String title;
  @HiveField(3)
  String venue;
  @HiveField(4)
  final int id;
  @HiveField(5)
 String? photo;

  EventModel(
      {required this.id,
      required this.eventDescription,
      required this.date,
      required this.title,
      required this.venue,this.photo});
}
