// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      email: fields[1] as dynamic,
      mobileNumber: fields[2] as String,
      stripeCustomerId: fields[3] as String,
      coins: fields[4] as int,
      authToken: fields[5] as dynamic,
      userTypeId: fields[6] as int,
      isNewUser: fields[7] as int,
      enableNewKrushNotification: fields[8] as int,
      enableNewChatMessageNotification: fields[9] as int,
      isActive: fields[10] as int,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      freeAcceptsAvailable: fields[13] as int,
      freeSendRequestAvailable: fields[14] as int,
      freeAdsViewed: fields[15] as int,
      pending_requests: fields[31] as int,
      accessToken: fields[16] as String,
      requestReceived: fields[33] as RequestReceived,
      tokenType: fields[17] as String,
      expiresIn: fields[18] as int,
      userId: fields[19] as int,
      firstName: fields[20] as dynamic,
      lastName: fields[21] as dynamic,
      profilePic: fields[22] as dynamic,
      displayName: fields[23] as String,
      gender: fields[24] as String,
      dateOfBirth: fields[25] as DateTime,
      firstDateLocation: fields[26] as String,
      country: fields[27] as dynamic,
      state: fields[28] as dynamic,
      city: fields[29] as dynamic,
      zipcode: fields[30] as dynamic,
      isSubscribed: fields[32] as int,
      transactionId: fields[34] as String,
      transactionDate: fields[35] as String,
      profanityFilter: fields[37] as int,
      userContactsUpdateDate: fields[36] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(38)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.mobileNumber)
      ..writeByte(3)
      ..write(obj.stripeCustomerId)
      ..writeByte(4)
      ..write(obj.coins)
      ..writeByte(5)
      ..write(obj.authToken)
      ..writeByte(6)
      ..write(obj.userTypeId)
      ..writeByte(7)
      ..write(obj.isNewUser)
      ..writeByte(8)
      ..write(obj.enableNewKrushNotification)
      ..writeByte(9)
      ..write(obj.enableNewChatMessageNotification)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.freeAcceptsAvailable)
      ..writeByte(14)
      ..write(obj.freeSendRequestAvailable)
      ..writeByte(15)
      ..write(obj.freeAdsViewed)
      ..writeByte(16)
      ..write(obj.accessToken)
      ..writeByte(17)
      ..write(obj.tokenType)
      ..writeByte(18)
      ..write(obj.expiresIn)
      ..writeByte(19)
      ..write(obj.userId)
      ..writeByte(20)
      ..write(obj.firstName)
      ..writeByte(21)
      ..write(obj.lastName)
      ..writeByte(22)
      ..write(obj.profilePic)
      ..writeByte(23)
      ..write(obj.displayName)
      ..writeByte(24)
      ..write(obj.gender)
      ..writeByte(25)
      ..write(obj.dateOfBirth)
      ..writeByte(26)
      ..write(obj.firstDateLocation)
      ..writeByte(27)
      ..write(obj.country)
      ..writeByte(28)
      ..write(obj.state)
      ..writeByte(29)
      ..write(obj.city)
      ..writeByte(30)
      ..write(obj.zipcode)
      ..writeByte(31)
      ..write(obj.pending_requests)
      ..writeByte(32)
      ..write(obj.isSubscribed)
      ..writeByte(33)
      ..write(obj.requestReceived)
      ..writeByte(34)
      ..write(obj.transactionId)
      ..writeByte(35)
      ..write(obj.transactionDate)
      ..writeByte(36)
      ..write(obj.userContactsUpdateDate)
      ..writeByte(37)
      ..write(obj.profanityFilter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
