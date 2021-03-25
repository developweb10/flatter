import 'gift_model.dart';
import 'gift_model_krushin.dart';

class Gift {
  int id;
  String orderNumber;
  int productId;
  int quantity;
  int relationId;
  int fromId;
  int toId;
  int isProcessed;
  String hasAccepted;
  DateTime created_at;
  DateTime updated_at;
  List<GiftModelKrushin> products;
  String name;
  String receiverAvatar;

  
  Gift({
    this.id,
    this.orderNumber,
    this.productId,
    this.quantity,
    this.relationId,
    this.fromId,
    this.toId,
    this.isProcessed,
    this.hasAccepted,
    this.created_at,
    this.updated_at,
    this.products,
    this.name,
    this.receiverAvatar
  });

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json["id"] == null ? null : json["id"],
        relationId: json["relationId"] == null ? null : json["relationId"],
        productId: json["productId"] == null ? null : json["productId"],
        orderNumber:
            json["orderNumber"] == null ? null : json["orderNumber"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        fromId: json["fromId"] == null ? null : json["fromId"],
        toId: json["toId"] == null ? null : json["toId"],
        isProcessed: json["isProcessed"] == null ? null : json["isProcessed"],
        hasAccepted: json["hasAccepted"] == null ? null : json["hasAccepted"],
        created_at: json["created_at"] == null ? null :DateTime.parse(json["created_at"]),
        updated_at: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        products: json["products"] == null
            ? null
            : List<GiftModelKrushin>.from(
                json["products"].map((x) => GiftModelKrushin.fromJson(x))),
        // products: json['products'] == null ? null : GiftModel.fromJson(json['products']),
        name: json["name"] == null ? "" : json["name"],
        receiverAvatar: json["receiverAvatar"] == null ? "" : json["receiverAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "relationId": relationId == null ? null : relationId,
        "productId": productId == null ? null : productId,
        "orderNumber": orderNumber == null ? null : orderNumber,
        "quantity": quantity == null ? null : quantity,
        "fromId": fromId == null ? null : fromId,
        "toId": toId == null ? null : toId,
        "isProcessed": isProcessed == null ? null : isProcessed,
        "hasAccepted": hasAccepted == null ? null : hasAccepted,
        "created_at": created_at == null ? null : created_at.toIso8601String(),
        "updated_at": updated_at == null ? null : updated_at.toIso8601String(),
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
        // "products" : products.toJson(),
        "name": name == null ? null : name,
        "receiverAvatar": receiverAvatar == null ? null : receiverAvatar,
      };
}