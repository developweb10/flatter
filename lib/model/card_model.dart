
class CardsModel{
  String last4;
  String exp_month;
  String exp_year;
  String paymentMethodId;


  CardsModel(
    this.last4,
    this.exp_month,
    this.exp_year,
    this.paymentMethodId,
  );

  CardsModel.map(dynamic obj) {
    this.last4 = obj['last4'];
    this.exp_month = obj['exp_month'];
    this.exp_year = obj['exp_year'];
    this.paymentMethodId = obj['paymentMethodId'];     

  }
      

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['last4'] = last4;
    map['exp_month'] = exp_month;
    map['exp_year'] = exp_year;
    map['paymentMethodId'] = paymentMethodId;

    return map;
  }



  CardsModel.fromMap(Map<String, dynamic> map)  {
    this.last4 = map['last4'];
    this.exp_month = map['exp_month'];
    this.exp_year = map['exp_year'];
    this.paymentMethodId = map['paymentMethodId'];

  }

}
