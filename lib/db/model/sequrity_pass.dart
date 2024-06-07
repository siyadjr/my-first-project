import 'package:hive_flutter/hive_flutter.dart';
part 'sequrity_pass.g.dart';


@HiveType(typeId: 2)
class SequrityPass {
  @HiveField(0)
  final String? question; 
  @HiveField(1)
  final String? answer;

  SequrityPass({required this.question, required this.answer}); 



}
