import 'package:hive/hive.dart';

part 'blocked_conversation_model.g.dart';

@HiveType(typeId:3)
class BlockedConversationModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String mobileNumber;

  @HiveField(2)
  int userTypeId;

  @HiveField(3)
  int isActive;

  @HiveField(4)
  int relationId;

  @HiveField(5)
  bool sentRequest;

  @HiveField(6)
  bool hasRevealed;

  @HiveField(7)
  bool receiverSeenRevealRequest;

  @HiveField(8)
  String createdAt;

  @HiveField(9)
  String updatedAt;

  @HiveField(10)
  String chatName;

  @HiveField(11)
  String avatar;

  @HiveField(12)
  String blockedBy;

  BlockedConversationModel({
    this.id,
    this.mobileNumber,
    this.userTypeId,
    this.isActive,
    this.relationId,
    this.sentRequest,
    this.hasRevealed,
    this.receiverSeenRevealRequest,
    this.createdAt,
    this.updatedAt,
    this.chatName,
    this.avatar,
    this.blockedBy
  });

  BlockedConversationModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] == null ? null : json["id"],
        mobileNumber =
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        userTypeId = json["userTypeId"] == null ? null : json["userTypeId"],
        isActive = json["isActive"] == null ? null : json["isActive"],
        relationId = json['relationId'],
        sentRequest = json['sentRequest'],
        hasRevealed = json['hasRevealed'],
        receiverSeenRevealRequest = json['receiverSeenRevealRequest'],
        createdAt = json["created_at"],
        updatedAt = json["updated_at"],
        chatName = json["chatName"] == null ? '' : json["chatName"],
        avatar = json["avatar"] == null ? '' : json["avatar"],
        blockedBy = json['blockedBy'].toString();
}
