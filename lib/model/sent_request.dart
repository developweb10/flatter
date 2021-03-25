// To parse this JSON data, do
//
//     final sentRequest = sentRequestFromJson(jsonString);

import 'dart:convert';

SentRequest sentRequestFromJson(String str) =>
    SentRequest.fromJson(json.decode(str));

String sentRequestToJson(SentRequest data) => json.encode(data.toJson());

class SentRequest {
  String message;
  bool status;
  Data data;
  String reason;

  SentRequest({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory SentRequest.fromJson(Map<String, dynamic> json) => SentRequest(
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
  List<RequestSent> requestSent;

  Data({
    this.requestSent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestSent: json["request-sent"] == null
            ? null
            : List<RequestSent>.from(
                json["request-sent"].map((x) => RequestSent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request-sent": requestSent == null
            ? null
            : List<dynamic>.from(requestSent.map((x) => x.toJson())),
      };
}

class RequestSent {
  int userId;
  int relationId;
  String name;
  String receiverAvatar;
  String mobileNumber;
  String message;
  String status;

  RequestSent({
    this.userId,
    this.relationId,
    this.name,
    this.receiverAvatar,
    this.mobileNumber,
    this.message,
    this.status,
  });

  factory RequestSent.fromJson(Map<String, dynamic> json) => RequestSent(
        userId: json["userId"] == null ? null : json["userId"],
        relationId: json["relationId"] == null ? null : json["relationId"],
        name: json["name"] == null ? null : json["name"],
        mobileNumber:
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        receiverAvatar: json["receiverAvatar"] == null ? null : json["receiverAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId == null ? null : userId,
        "relationId": relationId == null ? null : relationId,
        "name": name == null ? null : name,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "receiverAvatar": receiverAvatar == null ? null : receiverAvatar,
      };
}
