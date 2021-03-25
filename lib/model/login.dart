// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';

import 'user_model.dart';



Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String message;
  bool status;
  Data data;
  String reason;

  Login({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
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

