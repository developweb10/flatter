// To parse this JSON data, do
//
//     final billingAddress = billingAddressFromJson(jsonString);

import 'dart:convert';

import 'addressModel.dart';



BillingAddress billingAddressFromJson(String str) => BillingAddress.fromJson(json.decode(str));

String billingAddressToJson(BillingAddress data) => json.encode(data.toJson());

class BillingAddress {
  String message;
  bool status;
  Data data;
  String reason;

  BillingAddress({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
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
  List<AddressModel> addressList;

  Data({
    this.addressList,
  });
  
  factory Data.fromJson(Map<String, dynamic> json) => Data(
          addressList: json["billing-address"] == null
            ? null
            : List<AddressModel>.from(
                json["billing-address"].map((x) => AddressModel.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
                "billing-address": addressList == null
            ? null
            : List<dynamic>.from(addressList.map((x) => x.toMap())),
      };
}

