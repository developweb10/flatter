// To parse this JSON data, do
//
//     final shippingAddress = shippingAddressFromJson(jsonString);

import 'dart:convert';

import 'addressModel.dart';



ShippingAddress shippingAddressFromJson(String str) => ShippingAddress.fromJson(json.decode(str));

String shippingAddressToJson(ShippingAddress data) => json.encode(data.toJson());

class ShippingAddress {
  String message;
  bool status;
  Data data;
  String reason;

  ShippingAddress({
    this.message,
    this.status,
    this.data,
    this.reason,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
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
          addressList: json["shipping-address"] == null
            ? null
            : List<AddressModel>.from(
                json["shipping-address"].map((x) => AddressModel.fromMap(x))),
      );

  Map<String, dynamic> toJson() => {
                "shipping-address": addressList == null
            ? null
            : List<dynamic>.from(addressList.map((x) => x.toMap())),
      };
}

