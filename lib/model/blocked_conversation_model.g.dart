// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_conversation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockedConversationModelAdapter
    extends TypeAdapter<BlockedConversationModel> {
  @override
  final int typeId = 3;

  @override
  BlockedConversationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockedConversationModel(
      id: fields[0] as int,
      mobileNumber: fields[1] as String,
      userTypeId: fields[2] as int,
      isActive: fields[3] as int,
      relationId: fields[4] as int,
      sentRequest: fields[5] as bool,
      hasRevealed: fields[6] as bool,
      receiverSeenRevealRequest: fields[7] as bool,
      createdAt: fields[8] as String,
      updatedAt: fields[9] as String,
      chatName: fields[10] as String,
      avatar: fields[11] as String,
      blockedBy: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BlockedConversationModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mobileNumber)
      ..writeByte(2)
      ..write(obj.userTypeId)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.relationId)
      ..writeByte(5)
      ..write(obj.sentRequest)
      ..writeByte(6)
      ..write(obj.hasRevealed)
      ..writeByte(7)
      ..write(obj.receiverSeenRevealRequest)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.chatName)
      ..writeByte(11)
      ..write(obj.avatar)
      ..writeByte(12)
      ..write(obj.blockedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockedConversationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
