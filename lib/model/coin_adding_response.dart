// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

CoinAddingResponse loginFromJson(String str) => CoinAddingResponse.fromJson(json.decode(str));

String loginToJson(CoinAddingResponse data) => json.encode(data.toJson());

class CoinAddingResponse {
  String message;
  bool status;
  Data data;

  String reason;

  CoinAddingResponse({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory CoinAddingResponse.fromJson(Map<String, dynamic> json) => CoinAddingResponse(
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
  User user;

  Data({
    this.user,
  });
  
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
      };
}

class User {
  int id;
  dynamic email;
  String mobileNumber;
  int coins;
  dynamic authToken;
  int userTypeId;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  User({
    this.id,
    this.email,
    this.mobileNumber,
    this.coins,
    this.authToken,
    this.userTypeId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        email: json["email"],
        mobileNumber:
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        coins: json["coins"],
        authToken: json["authToken"],
        userTypeId: json["userTypeId"] == null ? null : json["userTypeId"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "coins" : coins,
        "authToken": authToken,
        "userTypeId": userTypeId == null ? null : userTypeId,
        "isActive": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
