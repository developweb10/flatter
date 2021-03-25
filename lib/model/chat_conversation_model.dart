import 'package:hive/hive.dart';
import 'package:krushapp/model/message_model.dart';

part 'chat_conversation_model.g.dart';

@HiveType(typeId: 0)
class ChatsConversationModel {
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
  Message lastMessage;

  @HiveField(13)
  bool isRead;

  @HiveField(14)
  String image;

  @HiveField(15)
  int unreadMessages;

  ChatsConversationModel({
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
    this.lastMessage,
    this.isRead,
    this.image,
    this.unreadMessages
  });

  ChatsConversationModel.fromJson(Map<String, dynamic> json)
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
        lastMessage = Message.fromJson(json["message"]),
        image = json['image'],
        unreadMessages = json['unreadMessageCount'],
        isRead = json["isRead"];

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "userTypeId": userTypeId == null ? null : userTypeId,
        "isActive": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "chatName": chatName == null ? null : chatName,
        "avatar": avatar == null ? null : avatar,
      };
}
