class GiftList {


List<Gifts> gifts;
int relationId;

GiftList(this.gifts, this.relationId); 


Map<String, dynamic> toJson() => <String, dynamic>{
    'relationId': relationId,
    'products': gifts,
  };
}

class Gifts {
Gifts({this.productId, this.quantity});

int productId;
int quantity;

Map<String, dynamic> toJson() => <String, dynamic>{
    'productId': productId,
    'quantity': quantity,
  };
}