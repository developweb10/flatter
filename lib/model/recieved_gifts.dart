// To parse this JSON data, do
//
//     final RecievedGifts = SentGiftsFromJson(jsonString);

import 'dart:convert';

import 'gift.dart';

RecievedGifts SentGiftsFromJson(String str) => RecievedGifts.fromJson(json.decode(str));

String SentGiftsToJson(RecievedGifts data) => json.encode(data.toJson());

class RecievedGifts {
  String message;
  bool status;
  Data data;
  String reason;

  RecievedGifts({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory RecievedGifts.fromJson(Map<String, dynamic> json) => RecievedGifts(
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
  List<Gift> giftRecieved;

  Data({
    this.giftRecieved,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        giftRecieved: json["received-gifts"] == null
            ? null
            : List<Gift>.from(
                json["received-gifts"].map((x) => Gift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "received-gifts": Gift == null
            ? null
            : List<dynamic>.from(giftRecieved.map((x) => x.toJson())),
      };
}
