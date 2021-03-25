
class AllContactsList{
  List<ContactModel> userContacts;

AllContactsList(this.userContacts); 
Map<String, dynamic> toJson() => <String, dynamic>{
    'userContacts': userContacts
  };
}



class ContactList {


List<ContactModel> unblock_contactList;
List<ContactModel> block_contactList;

ContactList(this.block_contactList, this.unblock_contactList); 


Map<String, dynamic> toJson() => <String, dynamic>{
    'blockContacts': block_contactList,
    'unblockContacts': unblock_contactList
  };
}

class ContactModel {
ContactModel({this.name, this.phone});

String name;
String phone;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        name: json["name"] == null ? null : json["name"],
        phone: json["number"] == null ? null : json["number"],
      );

Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'number': phone,
  };
}





