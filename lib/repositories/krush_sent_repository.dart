

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/model/result.dart';
import 'package:krushapp/model/sent_request.dart';
import 'package:krushapp/utils/Constants.dart';

import '../model/recieve_request.dart';

import '../app/api.dart';

class KrushSentRepository {
  ApiClient _client;

  KrushSentRepository() : _client = ApiClient.apiClient;

  Future<SentRequest> getSentRequests() async {
    try {
        return await ApiClient.apiClient.getSentRequestAction();
    } catch (e) {
      throw e;
    }
      }


}
