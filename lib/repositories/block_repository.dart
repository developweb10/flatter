
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/blocked_contacts.dart';
import 'package:krushapp/model/contact_model.dart';
import 'package:krushapp/model/result.dart';
import 'package:krushapp/utils/Constants.dart';

class BlockRepository {



sendBlockList(List<ContactModel> original_list, List<ContactModel> new_list) async {

List<ContactModel> blocked = [];
List<ContactModel> unblocked = [];

for(ContactModel contact in original_list){
    List value = new_list.where((element) {
       return element.phone == contact.phone;
    }).toList();
 if(value == null || value.length == 0){
    unblocked.add(contact);
 }
}

for(ContactModel contact in new_list){

    List value = original_list.where((element) {
       return element.phone == contact.phone;
    }).toList();
 if(value == null || value.length == 0){

    blocked.add(contact);
 }
}

return await ApiClient.apiClient.sendContacts(blocked, unblocked);
}


}
