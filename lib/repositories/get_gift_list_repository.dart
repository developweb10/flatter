

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/gift_model.dart';
import 'package:krushapp/utils/Constants.dart';

class GetGiftListRepository {

static List<GiftModel> gifts_list;

  getGifts() async {

    String body = await ApiClient.apiClient.getGifts();
    gifts_list = List<GiftModel>.from(json.decode(body)
                .map((x) => GiftModel.fromJson(x)));
  }

}
