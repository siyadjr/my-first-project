// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskDetailsAdapter extends TypeAdapter<TaskDetails> {
  @override
  final int typeId = 5;

  @override
  TaskDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskDetails(
      taskname: fields[0] as String,
      taskDescription: fields[1] as String,
      date: fields[2] as String,
      id: fields[3] as int,
      photo: fields[4] as String?,
      selectedMemberIds: (fields[5] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.taskname)
      ..writeByte(1)
      ..write(obj.taskDescription)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.photo)
      ..writeByte(5)
      ..write(obj.selectedMemberIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
