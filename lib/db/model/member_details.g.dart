// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MembersAdapter extends TypeAdapter<Members> {
  @override
  final int typeId = 3;

  @override
  Members read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Members(
      name: fields[0] as String,
      role: fields[1] as String,
      phone: fields[2] as String,
      strength: fields[3] as String,
      photo: fields[4] as String?,
      id: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Members obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.strength)
      ..writeByte(4)
      ..write(obj.photo)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
