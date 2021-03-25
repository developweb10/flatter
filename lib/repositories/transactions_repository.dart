import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';

class TransactionsRepository {
  getTransactions(String stripeId) async {
    String phoneNumber = await UserSettingsManager.getUserPhone();
    String token = await UserSettingsManager.getUserPhone();

    List transactions = [];
    if (stripeId == null) {
      stripeId = await getStripeId(token, phoneNumber);
      UserSettingsManager.setStripeId(stripeId);
    }

    await listTransactions(token, stripeId).then((value) {
      if (value['status']) {
        for (int i = 0; i < value['data']['charges']['data'].length; i++) {
          transactions.add(value['data']['charges']['data'][i]['amount'] / 100);
        }
      }
    });

    return transactions;
  }

  getStripeId(String token, String phone) async {
    Map<String, String> jsonMap = {"mobileNumber": phone};

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await Client().post(
          "${ApiClient.apiClient.baseUrl}/create_stripe_customer",
          body: jsonMap,
          headers: headers);
      final parsed = json.decode(response.body);
      return parsed["data"]["customerId"];
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  listTransactions(String token, String customerId) async {
    Map<String, String> jsonMap = {
      "stripeCustomerId": customerId,
      "limit": "10"
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await Client().post(
          "${ApiClient.apiClient.baseUrl}/customer_transactions",
          body: jsonMap,
          headers: headers);
      final parsed = json.decode(response.body);
      return parsed;
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }
}
