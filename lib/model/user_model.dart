import 'package:hive/hive.dart';

import 'recieve_request.dart';
part 'user_model.g.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  dynamic email;
  @HiveField(2)
  String mobileNumber;
  @HiveField(3)
  String stripeCustomerId;
  @HiveField(4)
  int coins;
  @HiveField(5)
  dynamic authToken;
  @HiveField(6)
  int userTypeId;
  @HiveField(7)
  int isNewUser;
  @HiveField(8)
  int enableNewKrushNotification;
  @HiveField(9)
  int enableNewChatMessageNotification;
  @HiveField(10)
  int isActive;
  @HiveField(11)
  DateTime createdAt;
  @HiveField(12)
  DateTime updatedAt;
  @HiveField(13)
  int freeAcceptsAvailable;
  @HiveField(14)
  int freeSendRequestAvailable;
  @HiveField(15)
  int freeAdsViewed;
  @HiveField(16)
  String accessToken;
  @HiveField(17)
  String tokenType;
  @HiveField(18)
  int expiresIn;
  @HiveField(19)
  int userId;
  @HiveField(20)
  dynamic firstName;
  @HiveField(21)
  dynamic lastName;
  @HiveField(22)
  dynamic profilePic;
  @HiveField(23)
  String displayName;
  @HiveField(24)
  String gender;
  @HiveField(25)
  DateTime dateOfBirth;
  @HiveField(26)
  String firstDateLocation;
  @HiveField(27)
  dynamic country;
  @HiveField(28)
  dynamic state;
  @HiveField(29)
  dynamic city;
  @HiveField(30)
  dynamic zipcode;
  @HiveField(31)
  int pending_requests;
  @HiveField(32)
  int isSubscribed;
  @HiveField(33)
  RequestReceived requestReceived;
  @HiveField(34)
  String transactionId;
  @HiveField(35)
  String transactionDate;
  @HiveField(36)
  String userContactsUpdateDate;
  @HiveField(37)
  int profanityFilter;

  User(
      {this.id,
      this.email,
      this.mobileNumber,
      this.stripeCustomerId,
      this.coins,
      this.authToken,
      this.userTypeId,
      this.isNewUser,
      this.enableNewKrushNotification,
      this.enableNewChatMessageNotification,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.freeAcceptsAvailable,
      this.freeSendRequestAvailable,
      this.freeAdsViewed,
      this.pending_requests,
      this.accessToken,
      this.requestReceived,
      this.tokenType,
      this.expiresIn,
      this.userId,
      this.firstName,
      this.lastName,
      this.profilePic,
      this.displayName,
      this.gender,
      this.dateOfBirth,
      this.firstDateLocation,
      this.country,
      this.state,
      this.city,
      this.zipcode,
      this.isSubscribed,
      this.transactionId,
      this.transactionDate,
      this.profanityFilter,
      this.userContactsUpdateDate});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] == null ? null : json["id"],
      email: json["email"],
      mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
      stripeCustomerId:
          json["stripeCustomerId"] == null ? null : json["stripeCustomerId"],
      coins: json["coins"],
      authToken: json["authToken"],
      userTypeId: json["userTypeId"] == null ? null : json["userTypeId"],
      isActive: json["isActive"] == null ? null : json["isActive"],
      isNewUser: json["isNewUser"] == null ? null : json["isNewUser"],
      freeAcceptsAvailable: json["freeAcceptsAvailable"],
      freeSendRequestAvailable: json["freeSendRequestAvailable"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      enableNewKrushNotification: json["enableNewKrushNotification"],
      enableNewChatMessageNotification:
          json["enableNewChatMessageNotification"],
      freeAdsViewed: json["freeAdsViewed"],
      pending_requests: json["pending_requests"],
      accessToken: json["access_token"] == null ? null : json["access_token"],
      requestReceived: json["first_pending_request"] == null
          ? null
          : RequestReceived.fromJson(json["first_pending_request"]),
      tokenType: json["token_type"] == null ? null : json["token_type"],
      expiresIn: json["expires_in"] == null ? null : json["expires_in"],
      userId: json["userId"] == null ? null : json["userId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      profilePic: json["profilePic"],
      displayName: json["displayName"] == null ? null : json["displayName"],
      gender: json["gender"] == null ? null : json["gender"],
      dateOfBirth: json["dateOfBirth"] == null
          ? null
          : DateTime.parse(json["dateOfBirth"]),
      firstDateLocation:
          json["firstDateLocation"] == null ? null : json["firstDateLocation"],
      country: json["country"],
      state: json["state"],
      city: json["city"],
      zipcode: json["zipcode"],
      isSubscribed: json["isSubscribed"],
      transactionId: json["transactionId"],
      transactionDate: json["transactionDate"],
      profanityFilter: json['profanityFilter'],
      userContactsUpdateDate: json["user_contact_last_updated_date"]);

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "stripeCustomerId": stripeCustomerId,
        "coins": coins,
        "authToken": authToken,
        "userTypeId": userTypeId == null ? null : userTypeId,
        "isNewUser": isNewUser == null ? 1 : isNewUser,
        "enableNewKrushNotification": enableNewKrushNotification,
        "enableNewChatMessageNotification": enableNewChatMessageNotification,
        "isActive": isActive == null ? null : isActive,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "freeAcceptsAvailable": freeAcceptsAvailable,
        "freeSendRequestAvailable": freeSendRequestAvailable,
        "freeAdsViewed": freeAdsViewed,
        "pending_requests": pending_requests ?? 0,
        "access_token": accessToken == null ? null : accessToken,
        "first_pending_request":
            requestReceived == null ? null : requestReceived.toJson(),
        "token_type": tokenType == null ? null : tokenType,
        "expires_in": expiresIn == null ? null : expiresIn,
        "userId": userId == null ? null : userId,
        "firstName": firstName,
        "lastName": lastName,
        "profilePic": profilePic,
        "displayName": displayName == null ? null : displayName,
        "gender": gender == null ? null : gender,
        "dateOfBirth": dateOfBirth == null
            ? null
            : "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "firstDateLocation":
            firstDateLocation == null ? null : firstDateLocation,
        "country": country,
        "state": state,
        "city": city,
        "zipcode": zipcode,
        'profanityFilter':profanityFilter,
        "isSubscribed": isSubscribed,
        "transactionId": transactionId,
        "transactionDate": transactionDate,
        "user_contact_last_updated_date": userContactsUpdateDate
      };
}
