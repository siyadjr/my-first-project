// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_details_.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamDetailsAdapter extends TypeAdapter<TeamDetails> {
  @override
  final int typeId = 1;

  @override
  TeamDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamDetails(
      teamName: fields[0] as String?,
      teamAbout: fields[1] as String?,
      teamPhoto: fields[2] as String?,
      memberIds: (fields[3] as List?)?.cast<int>(),
      taskIds: (fields[4] as List?)?.cast<int>(),
      id: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TeamDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.teamName)
      ..writeByte(1)
      ..write(obj.teamAbout)
      ..writeByte(2)
      ..write(obj.teamPhoto)
      ..writeByte(3)
      ..write(obj.memberIds)
      ..writeByte(4)
      ..write(obj.taskIds)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
