// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as int,
      senderId: fields[1] as int,
      time: fields[2] as String,
      text: fields[3] as String,
      isLiked: fields[4] as bool,
      unread: fields[5] as bool,
      image: fields[6] as String,
      type: fields[8] as String,
      sending: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.isLiked)
      ..writeByte(5)
      ..write(obj.unread)
      ..writeByte(6)
      ..write(obj.image)
      ..writeByte(7)
      ..write(obj.sending)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
