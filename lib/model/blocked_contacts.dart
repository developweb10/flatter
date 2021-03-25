// To parse this JSON data, do
//
//     final BlockedContacts = SentGiftsFromJson(jsonString);

import 'dart:convert';

import 'package:krushapp/model/receivedModel.dart';

import 'contact_model.dart';


BlockedContacts SentGiftsFromJson(String str) => BlockedContacts.fromJson(json.decode(str));

String SentGiftsToJson(BlockedContacts data) => json.encode(data.toJson());

class BlockedContacts {
  String message;
  bool status;
  Data data;
  String reason;

  BlockedContacts({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory BlockedContacts.fromJson(Map<String, dynamic> json) => BlockedContacts(
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
  List<ReceivedContactModel> receivedContacts;

  Data({
    this.receivedContacts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        receivedContacts: json["blocked-contacts"] == null
            ? null
            : List<ReceivedContactModel>.from(
                json["blocked-contacts"].map((x) => ReceivedContactModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blocked-contacts": ReceivedContactModel == null
            ? null
            : List<dynamic>.from(receivedContacts.map((x) => x.toJson())),
      };
}
