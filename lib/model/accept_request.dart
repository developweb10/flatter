
import 'dart:convert';

List<AcceptRequestData> acceptRequestDataFromJson(String str) => List<AcceptRequestData>.from(json.decode(str).map((x) => AcceptRequestData.fromJson(x)));

String acceptRequestDataToJson(List<AcceptRequestData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AcceptRequestData {
  int id;
  dynamic email;
  String mobileNumber;
  dynamic authToken;
  int userTypeId;
  int isActive;
  int relationId;
  bool sentRequest;
  bool hasRevealed;
  bool receiverSeenRevealRequest;
  DateTime createdAt;
  DateTime updatedAt;
  String chatName;
  String avatar;

  AcceptRequestData({
    this.id,
    this.email,
    this.mobileNumber,
    this.authToken,
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
  });
  factory AcceptRequestData.fromJson(Map<String, dynamic> json) => AcceptRequestData(
    id: json["id"] == null ? null : json["id"],
    email: json["email"],
    mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
    authToken: json["authToken"],
    userTypeId: json["userTypeId"] == null ? null : json["userTypeId"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    relationId: json['relationId'],
    sentRequest: json['sentRequest'],
    hasRevealed: json['hasRevealed'],
    receiverSeenRevealRequest: json['receiverSeenRevealRequest'],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    chatName: json["chatName"] == null ? null : json["chatName"],
    avatar: json["avatar"] == null ? null : json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "email": email,
    "mobileNumber": mobileNumber == null ? null : mobileNumber,
    "authToken": authToken,
    "userTypeId": userTypeId == null ? null : userTypeId,
    "isActive": isActive == null ? null : isActive,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "chatName": chatName == null ? null : chatName,
    "avatar": avatar == null ? null : avatar,
  };
}


/*
import 'dart:convert';
import 'dart:async';


AcceptRequestData acceptRequestFromJson(String str) =>
    AcceptRequestData.fromJson(json.decode(str));

String acceptRequestToJson(AcceptRequestData data) => json.encode(data.toJson());

class AcceptRequestData {
  String message;
  bool status;
  Data data;
  String reason;

  AcceptRequestData({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory AcceptRequestData.fromJson(Map<String, dynamic> json) => AcceptRequestData(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    reason: json["reason"] == null ? null : json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
    "data": data == null ? null : data.toJson(),
    "reason": reason == null ? null : reason,
  };
}

class Data {
  List<AcceptRequestBody> requestReceived;

  Data({
    this.requestReceived,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    requestReceived: json["request-received"] == null
        ? null
        : List<AcceptRequestBody>.from(json["request-received"]
        .map((x) => AcceptRequestBody.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "request-received": requestReceived == null
        ? null
        : List<dynamic>.from(requestReceived.map((x) => x.toJson())),
  };
}






class AcceptRequestBody {
  int id;
  Null email;
  String mobileNumber;
  Null authToken;
  int userTypeId;
  int isActive;
  String createdAt;
  String updatedAt;
  String chatName;
  Null avatar;

  AcceptRequestBody(
      {this.id,
        this.email,
        this.mobileNumber,
        this.authToken,
        this.userTypeId,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.chatName,
        this.avatar});

  AcceptRequestBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    authToken = json['authToken'];
    userTypeId = json['userTypeId'];
    isActive = json['isActive'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    chatName = json['chatName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['mobileNumber'] = this.mobileNumber;
    data['authToken'] = this.authToken;
    data['userTypeId'] = this.userTypeId;
    data['isActive'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['chatName'] = this.chatName;
    data['avatar'] = this.avatar;
    return data;
  }
}*/
