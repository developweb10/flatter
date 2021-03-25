
class AddressModel{
  int id;
  int userId;
  String addressLine;
  String city;
  String state;
  String country;
  String zipcode;
  String phoneNumber;


  AddressModel(
    this.id,
    this.userId,
    this.addressLine,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.phoneNumber
  );

  AddressModel.map(dynamic obj) {
    this.id = obj['id'];
    this.userId = obj['userId'];
    this.addressLine = obj['addressLine1'];
    this.city = obj['city'];
    this.state = obj['state'];
    this.country = obj['country'];  
    this.zipcode = obj['zipcode'];    
    this.phoneNumber = obj['phoneNumber'];

  }
      

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['userId'] = userId;
    map['addressLine1'] = addressLine;
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    map['zipcode'] = zipcode;
    map['phoneNumber'] = phoneNumber;

    return map;
  }



  AddressModel.fromMap(Map<String, dynamic> map)  {
    this.id = map['id'];
    this.userId = map['userId'];
    this.addressLine = map['addressLine1'];
    this.city = map['city'];
    this.state = map['state'];
    this.country = map['country'];  
    this.zipcode = map['zipcode'];   
    this.phoneNumber = map['phoneNumber']; 

  }

}
