

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/model/result.dart';
import 'package:krushapp/utils/Constants.dart';

import '../model/recieve_request.dart';

import '../app/api.dart';

class KrushRecievedRepository {

  

  KrushRecievedRepository();

  Future<RecieveRequest> getRecievedRequests(
       String requestType) async {
    try {
        return await ApiClient.apiClient.getPendingRequest( requestType);
    } catch (e) {
      throw e;
    }
      }

 


     
  
}
