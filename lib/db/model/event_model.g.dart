// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 6;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[4] as int,
      eventDescription: fields[0] as String,
      date: fields[1] as String,
      title: fields[2] as String,
      venue: fields[3] as String,
      photo: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eventDescription)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.venue)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.photo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
