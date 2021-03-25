import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import '../app/api.dart';
import '../app/shared_prefrence.dart';
import '../model/recieve_request.dart';
import '../model/result.dart';
import 'number_format_repository.dart';
import '../utils/Constants.dart';

class KrushAddRepository {
  ApiClient _client;
  RecieveRequest recieveRequest;
  
  NumberFormatRepository numberFormatRepository = NumberFormatRepository();
  int coins_left;
  int free_requests;

  Future<bool> freeSendRequestsEnough() async {
    return (await UserSettingsManager.getFreesendRequestssAllowed() > 0);
  }

  Future<int> subscribed() async {
    return UserSettingsManager.getSubsciptionStatus();
  }

  Future<Result> sendRequest( String phoneNumber, String chatName,
      String krushName, String comment, String aviator) async {
    // String krushMobile = numberFormatRepository.changeNumber(phoneNumber);

    return await ApiClient.apiClient.addKrushRequestAction(
         krushName, chatName, phoneNumber, comment, aviator);
  }


}
