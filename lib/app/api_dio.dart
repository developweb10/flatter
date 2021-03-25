import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/gift_list.dart';
import 'package:krushapp/model/login.dart';
import 'package:http/http.dart' as http;
import 'package:krushapp/model/result.dart';

class ApiClientDio {
  ApiClientDio._();
  static final ApiClientDio apiClient = ApiClientDio._();
  Dio _safeDioClient;
  Dio refreshDioClient = Dio();
  final String baseUrl = 'https://krushin.world/api';
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<Login> loginAction() async {

    String userNumber = await UserSettingsManager.getUserPhone();
    userNumber = "+12222222222";
    String fcmToken = "test";
    String firebase_token = "token";
    await _fcm.getToken().then((value) => fcmToken = value);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.getIdToken().then((result) {
      firebase_token = result.token;
    });

    String platformType;
    if (Platform.isAndroid) {
      platformType = "android";
    } else if (Platform.isIOS) {
      platformType = "ios";
    } else {
      platformType = "unknown";
    }


    Map<String, String> jsonMap = {
      'mobileNumber': userNumber,
      'deviceId': fcmToken,
      'deviceType': platformType,
    };

    Map<String, String> headers = {"Authorization": "Bearer $firebase_token"};
    try {
      final response = await http.Client().post(
          "$baseUrl/authenticate_mobile_number",
          body: jsonMap,
          headers: headers);
      return parseLogin(response.body);
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  static Login parseLogin(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Login myUser = Login.fromJson(parsed);
      return myUser;
    } catch (e) {}
  }

  Dio getSafeDioClient() {
    print(_safeDioClient == null);
    if (_safeDioClient != null) {
      _safeDioClient.interceptors.clear();
    } else {
      _safeDioClient = Dio();
    }

    _safeDioClient.options.baseUrl = baseUrl;
    _safeDioClient.interceptors.add(InterceptorsWrapper(
      onRequest: (options) async {
        print('making a request');
        final accessToken = await UserSettingsManager.getUserToken();
        options.headers['Authorization'] = "Bearer $accessToken";
        return options;
      },
      onResponse: (response) {
        // print("response");
        // print(response);
        return response;
      },
      onError: (error) async {
        print('interceptor error ${error.message}');
        if (error.response.statusCode == 401) {
          print('Token error');
          _safeDioClient.interceptors.requestLock.lock();
          _safeDioClient.interceptors.responseLock.lock();
          RequestOptions options = error.response.request;

          Login login = await loginAction();
          String newToken = login.data.user.accessToken;
          print('new token $newToken');
          await UserSettingsManager.setUserToken(newToken);
          _safeDioClient.interceptors.requestLock.unlock();
          _safeDioClient.interceptors.responseLock.unlock();

          return _safeDioClient.request(options.path, options: options);
        } else {
          return error;
        }
      },
    ));

    return _safeDioClient;
  }

  sendGiftsDio(String token, int relationId, List gifts) async {
    final GiftList giftList = GiftList(
        List<Gifts>.generate(gifts.length, (int index) {
          return Gifts(productId: gifts[index], quantity: 1);
        }),
        relationId);

    final String requestBody = json.encoder.convert(giftList);

    print(requestBody);
    Map valueMap = json.decode(requestBody);
    FormData formData = FormData.fromMap(valueMap);
     Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      // Dio dio = Dio();
      // dio.options.baseUrl = baseUrl;
      // final accessToken = await UserSettingsManager.getUserToken();
      // dio.options.headers['Authorization'] = "Bearer $accessToken";

final response = await http.Client().post(
          "${baseUrl}/save_gift_order",
          body: requestBody,
          headers: headers);
      // final response = await dio.post("/save_gift_order", data: formData);
        print("response code: " + response.statusCode.toString());
      
if(response.statusCode ==401){
        print("response code: " + "401");
         Login login = await loginAction();
          String newToken = login.data.user.accessToken;
          print('new token $newToken');
          await UserSettingsManager.setUserToken(newToken);
          return sendGiftsDio(newToken, relationId, gifts);
      }else if(response.statusCode == 200){
         print("response successful");
     
       Result result = Result.fromJson(json.decode(response.body));
      if (result.status) {
        return true;
      } else {
        return result.message;
      }
      }
      
     
    }
     catch (e) {
      print( 'Error response $e');
      
      // if (e.statusCode == 401) {
          
      //     Login login = await loginAction();
      //     String newToken = login.data.user.accessToken;
      //     print('new token $newToken');
      //     await UserSettingsManager.setUserToken(newToken);
      //     return sendGiftsDio(token, relationId, gifts);
      //   }
     
      // else
      // throw e;
    }
  }
}
