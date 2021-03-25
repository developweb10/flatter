
import 'dart:convert';

List<GiftModel> acceptRequestDataFromJson(String str) => List<GiftModel>.from(json.decode(str).map((x) => GiftModel.fromJson(x)));

String acceptRequestDataToJson(List<GiftModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiftModel {
  int id;
  String name;
  String code;
  String price;
  String description;
  String dimension;
  String imageSmall;
  String imageLarge;
  String displayOnApp;
  DateTime createdAt;
  DateTime updatedAt;

  GiftModel({
    this.id,
    this.name,
    this.code,
    this.price,
    this.description,
    this.dimension,
    this.imageSmall,
    this.imageLarge,
    this.displayOnApp,
    this.createdAt,
    this.updatedAt,
  });


  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? "" : json["name"],
    code: json["code"],
    price: json["price"] == null ? null : json["price"],
    description: json["description"],
    dimension: json["dimension"] == null ? null : json["dimension"],
    imageSmall: json["imageSmall"] == null ? null : json["imageSmall"],
    imageLarge: json['imageLarge'],
    displayOnApp: json['displayOnApp'],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? "" : name,
    "code": code,
    "price": price == null ? null : price,
    "description": description,
    "dimension": dimension == null ? null : dimension,
    "imageSmall": imageSmall == null ? null : imageSmall,
    "imageLarge": imageLarge == null ? null : imageLarge,
    "displayOnApp": displayOnApp == null ? null : displayOnApp,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
