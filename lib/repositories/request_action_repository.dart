import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/recieve_request.dart';
import 'package:krushapp/model/result.dart';
import 'package:krushapp/repositories/number_format_repository.dart';
import 'package:krushapp/utils/Constants.dart';

class RequestActionRepository {
  ApiClient _client;
  RecieveRequest recieveRequest;
  String token;
  NumberFormatRepository numberFormatRepository = NumberFormatRepository();
  int coins_left;
  int free_requests;

  Future<bool> freeAcceptRequestsAllowed() async {
    return (await UserSettingsManager.getFreeAcceptRequestsAllowed() > 0);
  }

  Future<int> subscribed() async {
    return UserSettingsManager.getSubsciptionStatus();
  }

  Future<Result> applyAction(int relationId, String uri, String token) async {
    return await ApiClient.apiClient.requestActions(relationId, uri);
  }

  Future<Result> revokeRequest(int relationId, String uri, String token) async {
    return await ApiClient.apiClient.revokeRequest(relationId, uri);
  }

 
}
