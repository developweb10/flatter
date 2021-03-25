// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Sender registerFromJson(String str) => Sender.fromJson(json.decode(str));

String registerToJson(Sender data) => json.encode(data.toJson());

class Sender{
  String message;
  bool status;
  Data data;
  String reason;
  

  Sender({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        reason: json["reason"] == null ? null : json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
        "data": data == null  ? null: data,
        "reason": reason == null ? null : reason,
      };

  
}

class Data {
  User user;

  Data({
    this.user
  });
  
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["senderDetails"] == null ? null : User.fromJson(json["senderDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "senderDetails": user == null ? null : user.toJson(),
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
  Profile profile;

  User({
    this.id,
    this.email,
    this.mobileNumber,
    this.authToken,
    this.userTypeId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.profile
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        email: json["email"],
        mobileNumber:
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        authToken: json["authToken"],
        userTypeId: json["userTypeId"] == null ? null : json["userTypeId"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
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
        "profile": profile == null ? null : profile.toJson(),
      };
}

class Profile{
  int id;
  int userId;
  dynamic firstName;
  dynamic lastName;
  dynamic profilePic;
  String displayName;
  String gender;
  DateTime dateOfBirth;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zipcode;
  DateTime createdAt;
  DateTime updatedAt;
  String krushName;

    Profile({
    this.id,
  this.userId,
  this.firstName,
  this.lastName,
  this.profilePic,
  this.displayName,
  this.gender,
  this.dateOfBirth,
  this.country,
  this.state,
  this.city,
  this.zipcode,
  this.createdAt,
  this.updatedAt,
  this.krushName,
  });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"],
        firstName:
            json["firstName"] == null ? null : json["firstName"],
        lastName:
            json["lastName"] == null ? null : json["lastName"],
        profilePic:
            json["profilePic"] == null ? null : json["profilePic"],
        displayName:
            json["displayName"] == null ? null : json["displayName"],
        gender:
            json["gender"] == null ? null : json["gender"],
        dateOfBirth:
            json["dateOfBirth"] == null ? null :DateTime.parse(json["dateOfBirth"]) ,
        country:
            json["country"] == null ? null : json["country"],
        state:
            json["state"] == null ? null : json["state"],
        city:
            json["city"] == null ? null : json["city"],
        zipcode:
            json["zipcode"] == null ? null : json["zipcode"],
        createdAt:  json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
         updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        krushName:
            json["krushName"] == null ? null : json["krushName"],
      );

        Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "userId": userId,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName,
        "profilePic": profilePic == null ? null : profilePic,
        "displayName": displayName == null ? null : displayName,
        "gender": gender == null ? null : gender,
        "dateOfBirth": dateOfBirth == null ? null : dateOfBirth.toIso8601String(),
        "country": country == null ? null : country,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "zipcode": zipcode == null ? null : zipcode,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "krushName": krushName == null ? null : krushName,
      };
}

