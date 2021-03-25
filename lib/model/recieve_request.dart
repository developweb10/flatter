// To parse this JSON data, do
//
//     final recieveRequest = recieveRequestFromJson(jsonString);

import 'dart:convert';

RecieveRequest recieveRequestFromJson(String str) =>
    RecieveRequest.fromJson(json.decode(str));

String recieveRequestToJson(RecieveRequest data) => json.encode(data.toJson());

class RecieveRequest {
  String message;
  bool status;
  Data data;
  String reason;

  RecieveRequest({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory RecieveRequest.fromJson(Map<String, dynamic> json) => RecieveRequest(
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
  List<RequestReceived> requestReceived;

  Data({
    this.requestReceived,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestReceived: json["request-received"] == null
            ? null
            : List<RequestReceived>.from(json["request-received"]
                .map((x) => RequestReceived.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request-received": requestReceived == null
            ? null
            : List<dynamic>.from(requestReceived.map((x) => x.toJson())),
      };
}

class RequestReceived {
  int userId;
  String name;
  int relationId;
  String status;
  String comment;
  String senderAvatar;

  RequestReceived({
    this.userId,
    this.name,
    this.relationId,
    this.status,
    this.comment,
    this.senderAvatar,
  });

  factory RequestReceived.fromJson(Map<String, dynamic> json) =>
      RequestReceived(
        userId: json["userId"] == null ? null : json["userId"],
        name: json["name"] == null ? null : json["name"],
        relationId:
            json["relationId"] == null ? null : json["relationId"],
        status: json["status"] == null ? null : json["status"],
        comment: json["message"] == null ? null : json["message"],
        senderAvatar: json["senderAvatar"] == null ? "avatar1" : json["senderAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "name": name == null ? null : name,
        "relationId": relationId == null ? null : relationId,
        "status": status == null ? null : status,
        "message": comment == null ? null : comment,
        "senderAvatar": senderAvatar == null ? null : senderAvatar,
      };
}
