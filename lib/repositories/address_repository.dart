import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/billing_address.dart';
import '../model/addressModel.dart';
import '../model/shipping_address.dart';
import '../app/shared_prefrence.dart';
import '../utils/Constants.dart';

class AddressRepository {
  List<AddressModel> cardsList;

  Future<List<AddressModel>> getShippingAddress(String url) async {
    ShippingAddress shippingAddresses = await ApiClient.apiClient.listShippingAddresses( url
        );

    if (shippingAddresses.status) {
      
      if(shippingAddresses.data.addressList == null){
        return [];
      }else{
        return shippingAddresses.data.addressList;
      }

    }else{
      return [];
    }
    
  }

    Future<List<AddressModel>> getBillingAddress(String url) async {
    BillingAddress billingAddress = await ApiClient.apiClient.listBillingAddresses( url
        );

    if (billingAddress.status) {
      
      if(billingAddress.data.addressList == null){
        return [];
      }else{
        return billingAddress.data.addressList;
      }

    }else{
      return [];
    }
    
  }




}
