// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  String message;
  bool status;
  Data data;
  String reason;
  

  Register({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
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
   Profile profile;

  Data({
    this.user,
    this.profile

  });
  
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        profile: json["userProfile"] == null ? null : Profile.fromJson(json["userProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
        "userProfile": profile == null ? null : profile.toJson(),
      };
}

class User {
  int id;
  dynamic email;
  String mobileNumber;
    String stripeCustomerId;
  int coins;
  dynamic authToken;
  int userTypeId;
  int isNewUser;
  int enableNewKrushNotification;
  int enableNewChatMessageNotification;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  int freeAcceptsAvailable;
  int freeSendRequestAvailabled;
  int freeAdsViewed;
 

  User({
    this.id,
    this.email,
    this.mobileNumber,
        this.stripeCustomerId,
    this.authToken,
    this.userTypeId,
    this.isNewUser,
    this.enableNewKrushNotification,
    this.enableNewChatMessageNotification,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.freeAcceptsAvailable,
    this.freeSendRequestAvailabled,
    this.freeAdsViewed,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        email: json["email"],
        mobileNumber:
            json["mobileNumber"] == null ? null : json["mobileNumber"],
        stripeCustomerId:
            json["stripeCustomerId"] == null ? null : json["stripeCustomerId"],
        authToken: json["authToken"],
        userTypeId: json["userTypeId"] == null ? null : json["userTypeId"],
        isNewUser: json["isNewUser"],
        enableNewKrushNotification: json["enableNewKrushNotification"],
        enableNewChatMessageNotification: json["enableNewChatMessageNotification"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        freeAcceptsAvailable: json["freeAcceptsAvailable"],
        freeSendRequestAvailabled: json["freeSendRequestAvailable"],
        freeAdsViewed: json["freeAdsViewed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
         "stripeCustomerId": stripeCustomerId,
        "authToken": authToken,
        "userTypeId": userTypeId == null ? null : userTypeId,
        "isNewUser": isNewUser,
        "enableNewKrushNotification": enableNewKrushNotification,
        "enableNewChatMessageNotification": enableNewChatMessageNotification,
        "isActive": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "freeAcceptsAvailable" : freeAcceptsAvailable,
        "freeSendRequestAvailabled" : freeSendRequestAvailabled,
        "freeAdsViewed" : freeAdsViewed,
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

