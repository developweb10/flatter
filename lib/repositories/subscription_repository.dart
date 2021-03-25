import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/result.dart';
import '../utils/Constants.dart';

import '../app/shared_prefrence.dart';

class SubscriptionRepository {
  Future<int> checkSubscription() async {
    return await UserSettingsManager.getSubsciptionStatus();
  }

  Future<int> checkToShowSubsciptionDialog() async {
    return await UserSettingsManager.getsubscriptionShownStatus();
  }

  Future<Result> addSubscription(String subscriptionFlag, String transactionId,
      String transactionDate) async {
return ApiClient.apiClient.addSubscription( subscriptionFlag,  transactionId,
       transactionDate);
  }

  Future getVerificationDataJson(String verificationDataString) async {
    return ApiClient.apiClient.getVerificationDataJson(verificationDataString);
  }

  static String getRenewalTimeString(String dateString) {
    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateString, true);
    DateTime date = dateTime.toLocal();

    return date.toIso8601String();
  }
}
