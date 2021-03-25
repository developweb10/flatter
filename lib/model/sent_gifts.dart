// To parse this JSON data, do
//
//     final SentGifts = SentGiftsFromJson(jsonString);

import 'dart:convert';

import 'gift.dart';

SentGifts SentGiftsFromJson(String str) => SentGifts.fromJson(json.decode(str));

String SentGiftsToJson(SentGifts data) => json.encode(data.toJson());

class SentGifts {
  String message;
  bool status;
  Data data;
  String reason;

  SentGifts({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory SentGifts.fromJson(Map<String, dynamic> json) => SentGifts(
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
  List<Gift> giftSent;

  Data({
    this.giftSent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        giftSent: json["sent-gifts"] == null
            ? null
            : List<Gift>.from(
                json["sent-gifts"].map((x) => Gift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sent-gifts": giftSent == null
            ? null
            : List<dynamic>.from(giftSent.map((x) => x.toJson())),
      };
}
