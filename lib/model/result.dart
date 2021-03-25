// To parse this JSON data, do
//
//     final result = resultFromJson(jsonString);

import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  String message;
  bool status;
  Data data;
  String reason;
  
  Result({
    this.message,
    this.status,
    this.data,
    this.reason
    
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null || json["data"].isEmpty ? null : Data.fromJson(json["data"]),
        reason: json["reason"] == null ? null : json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
         "data": data == null  ? null: data,
        "reason": reason == null ? null : reason,
      };
}

class Data{
  int freeSendRequestAvailable;
  int freeAcceptsAvailable;
  int availableCoinsCount;
  Data(
    {
      
      this.freeSendRequestAvailable,
      this.freeAcceptsAvailable,
      this.availableCoinsCount
    }
  );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        freeSendRequestAvailable: json["freeSendRequestAvailable"] == null ? null : json["freeSendRequestAvailable"],
        freeAcceptsAvailable: json["freeAcceptsAvailable"] == null ? null : json["freeAcceptsAvailable"],
        availableCoinsCount: json["availableCoinsCount"] == null ? null : json["availableCoinsCount"],
      );

  Map<String, int> toJson() => {
        "freeSendRequestAvailable": freeSendRequestAvailable == null ? null : freeSendRequestAvailable,
        "freeAcceptsAvailable": freeAcceptsAvailable == null ? null : freeAcceptsAvailable,
        "availableCoinsCount": availableCoinsCount == null ? null : availableCoinsCount,
      };
}