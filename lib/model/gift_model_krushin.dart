
import 'dart:convert';

import 'gift_model.dart';

List<GiftModelKrushin> acceptRequestDataFromJson(String str) => List<GiftModelKrushin>.from(json.decode(str).map((x) => GiftModelKrushin.fromJson(x)));

String acceptRequestDataToJson(List<GiftModelKrushin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GiftModelKrushin {
  int id;
int orderId;
int productId;
int quantity;
  DateTime createdAt;
  DateTime updatedAt;
GiftModel product;

  GiftModelKrushin({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.product
  });


  factory GiftModelKrushin.fromJson(Map<String, dynamic> json) {

    return GiftModelKrushin(
    id: json["id"] == null ? null : json["id"],
    orderId: json["orderId"],
    productId: json["productId"] == null ? null : json["productId"],
    quantity: json["quantity"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    product: json["product"] == null ? null : GiftModel.fromJson(json["product"]),
  );
  } 

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "orderId": orderId,
    "productId": productId == null ? null : productId,
    "quantity": quantity,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
     "product": product == null ? null : product.toJson(),
  };
}
