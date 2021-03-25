import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import '../app/shared_prefrence.dart';
import '../model/card_model.dart';
import '../utils/Constants.dart';

class PaymentPageRepository {
  List<CardsModel> cardsList;

  Future<List<CardsModel>> getCards() async {
    cardsList = [];
    var value = await ApiClient.apiClient.listPaymentMethods(await UserSettingsManager.getStripeId(),
        );

    if (value['status']) {
      for (int i = 0; i < value['data']['paymentsMethod']['data'].length; i++) {
        cardsList.add(CardsModel(
            value['data']['paymentsMethod']['data'][i]['card']['last4'],
            value['data']['paymentsMethod']['data'][i]['card']['exp_month']
                .toString(),
            (value['data']['paymentsMethod']['data'][i]['card']['exp_year']
                    .toString())
                .substring(2),
            value['data']['paymentsMethod']['data'][i]['id']));
      }
      // if(cardsList == null){
      //   return [];
      // }

    }
    return cardsList;
  }




}
