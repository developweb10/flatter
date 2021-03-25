import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:krushapp/model/register.dart';
import 'package:krushapp/repositories/subscription_repository.dart';
import '../model/billing_address.dart';
import '../model/blocked_contacts.dart';
import '../model/contact_model.dart';
import '../model/gift_list.dart';
import '../model/recieve_request.dart';
import '../model/recieved_gifts.dart';
import '../model/result.dart';
import '../model/sent_gifts.dart';
import '../model/sent_request.dart';
import '../model/shipping_address.dart';
import '../utils/Constants.dart';
import '../model/coin_adding_response.dart';
import '../model/get_user_response.dart';
import '../model/login.dart';
import '../model/message_model.dart';
import '../model/sender.dart';
import '../utils/app_exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart' as async;

import 'shared_prefrence.dart';

class ApiClient {
  ApiClient._();

  final String baseUrl = 'https://krushin.world/api';

  static final ApiClient apiClient = ApiClient._();

  static final http.Client _httpClient = http.Client();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> getRefreshToken() async {
          Login login = await loginAction();
          String newToken = login.data.user.accessToken;
          await UserSettingsManager.setUserToken(newToken);
          return newToken;
  }

  Future<Login> loginAction({String userPhoneNumber}) async {

    if(userPhoneNumber == null){
       userPhoneNumber = await UserSettingsManager.getUserPhone();
    }

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
      'mobileNumber': userPhoneNumber,
      'deviceId': fcmToken,
      'deviceType': platformType,
    };

    Map<String, String> headers = {"Authorization": "Bearer $firebase_token"};
    try {
      final response = await _httpClient.post(
          "$baseUrl/authenticate_mobile_number",
          body: jsonMap,
          headers: headers);
      return parseLogin(response.body);
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error(e);
    }
  }

  static Login parseLogin(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Login myUser = Login.fromJson(parsed);
      return myUser;
    } catch (e) {
    }
  }

  Future<String> getStripeId(String userNumber) async {
        String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {'mobileNumber': userNumber};

    Map<String, String> headers = {"Authorization": "Bearer $token"};
    try {
      final response = await _httpClient.post("$baseUrl/create_stripe_customer",
          body: jsonMap, headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getStripeId(userNumber);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);
        return parsed['data']['customerId'];
      }else{
        return "";
      }

    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      // return Future.error("Server Error");
    }
  }

  Future<dynamic> getUserConversations() async {
            String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer $token"
    };
    var responseJson;
    try {
      final response =
          await _httpClient.get("$baseUrl/get_user_krush", headers: headers);
      
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getUserConversations();
      }else if(response.statusCode == 200){
        responseJson = _returnResponse(response);
        return responseJson;
      }else{
        return "";
      }
      
      // responseJson.forEach((element) {
      // });
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw e;
    }
  
  }

  Future<dynamic> getInitialMessages(String senderId) async {
       String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer $token"
    };
    var responseJson;
    try {
      final response = await _httpClient
          .get("$baseUrl/latest_messages_by_user/$senderId", headers: headers);

      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getInitialMessages(senderId);
      }else if(response.statusCode == 200){
        responseJson = _returnResponse(response);
        return responseJson;
      }else{
        return "";
      }
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw e;
    }

    return responseJson;
  }

  Future<dynamic> getPreviousMessages(
      String lastMessageId) async {
         String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer $token"
    };
    var responseJson;
    try {
      final response = await _httpClient.get(
          "$baseUrl/previous_messages/$lastMessageId/20",
          headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getPreviousMessages(lastMessageId);
      }else if(response.statusCode == 200){
        responseJson = _returnResponse(response);
        return responseJson;
      }else{
        return "";
      }
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw e;
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<List<Message>> getMessages( String userId) async {
    
         String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      List<Message> messagesList = List();
      final response = await _httpClient
          .get("$baseUrl/fetch_private_messages/$userId", headers: headers);


      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getMessages(userId);
      }else if(response.statusCode == 200){
              List<dynamic> parsed = await json.decode(response.body);


      parsed.forEach((element) {
        messagesList.add(Message(
          id: element['id'],
          isLiked: false,
          time: element['created_at'],
          text: element['message'],
          unread: true,
          senderId: element['fromUserId'],
        ));
      });
      return messagesList;
      }else{
        return [];
      }



    } catch (e) {
    }
  }

  Future sendMessage( String userId, String message, String relationId,
      {String gifUrl}) async {
         String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    Map<String, String> jsonMap = {
      'message': message,
      'relationId': relationId
    };
    if (gifUrl != null) jsonMap['file'] = gifUrl;
    var body = jsonEncode(jsonMap);
    try {
      final response = await _httpClient.post(
          "$baseUrl/private_messages/$userId",
          body: body,
          headers: headers);

if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return sendMessage(userId, message, relationId, gifUrl: gifUrl);
      }else if(response.statusCode == 200){
        final parsed = await json.decode(response.body);
      return parsed;
      }else{
        return "";
      }

   
    } catch (e) {
    }
  }

  Future deleteMessageForMe( String messageId) async {
             String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient.get("$baseUrl/delete_for/$messageId",
          headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return deleteMessageForMe( messageId);
      }
    } catch (e) {
    }
  }

  Future deleteMessageForAll( String messageId) async {
    String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient
          .get("$baseUrl/delete_for_all/$messageId", headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return deleteMessageForAll( messageId);
      }
    } catch (e) {
    }
  }

  Future sendImageMessage( String userId, File imageFile,
      String message, String relationId) async {
          String token = await UserSettingsManager.getUserToken();
    try {
      var stream = new http.ByteStream(
          async.DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("https://krushin.site/api/private_messages/$userId");

      var request = new http.MultipartRequest("POST", uri);
      request.fields['message'] = message;
      request.fields['relationId'] = relationId;
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: path.basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));
      request.headers['Authorization'] = "bearer " + token;

      request.files.add(multipartFile);

      var sentRequest = await request.send();

    

      if(sentRequest.statusCode == 401){
        String newToken = await getRefreshToken();
        return sendImageMessage( userId,  imageFile,
       message,relationId);
      }else if(sentRequest.statusCode == 200){
          var response = await sentRequest.stream.transform(utf8.decoder).first;
             final parsed = await json.decode(response);
 
      return parsed;
      }else{
        return "";
      }



    } catch (e) {
    }
  }

  Future revealKrush( String relationId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient
          .get("$baseUrl/reveal_krush/$relationId", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return revealKrush( relationId);
      }else if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    } catch (e) {
    }
  }

  Future<Sender> seenReveal( String relationId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient.get(
          "$baseUrl/receiver_seen_reveal_request/$relationId",
          headers: headers);


          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return seenReveal( relationId);
      }else if(response.statusCode == 200){
        final Map<String, dynamic> parsed = json.decode(response.body);
      Sender result = Sender.fromJson(parsed);
      return result;
      }else{
        return null;
      }

      
    } catch (e) {
      throw e;
    }
  }

  Future typingMessage(String userId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient.get("$baseUrl/typing_message/$userId",
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return typingMessage(userId);
      }else if(response.statusCode == 200){
      }else{
        return "";
      }
    } catch (e) {
      throw e;
    }
  }

  Future markMessageSeen(String userId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient
          .get("$baseUrl/mark_messages_read/$userId", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return markMessageSeen(userId);
      }else if(response.statusCode == 200){
        final parsed = await json.decode(response.body);
      return parsed;
      }else{
        return "";
      }
      
    } catch (e) {
      throw e;
    }
  }

  Future markMessageLiked( String messageId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };
    try {
      final response = await _httpClient.get("$baseUrl/like_message/$messageId",
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return markMessageLiked( messageId);
      }else if(response.statusCode == 200){
      }else{
        return "";
      }
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getBlockedKrushes() async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer $token"
    };
    var responseJson;
    try {
      final response =
          await _httpClient.get("$baseUrl/get_blocked_krush", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getBlockedKrushes();
      }else if(response.statusCode == 200){
            responseJson = _returnResponse(response);
      return responseJson;
      }else{
        return "";
      }
  
      
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw e;
    }
   
  }

  Future blockKrush( String relationId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    Map<String, String> jsonMap = {
      'relationId': relationId,
    };
    try {
      final response = await _httpClient.post("$baseUrl/block_krush",
          body: jsonMap, headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return blockKrush( relationId);
      }else if(response.statusCode == 200){
      }else{
        return "";
      }
    } catch (e) {
      throw e;
    }
  }

  Future toggleProfanityFilter( int status) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer $token"};
    Map<String, String> jsonMap = {
      'profanityFilter': status.toString(),
    };
    try {
      final response = await _httpClient.post(
          "$baseUrl/toggle_profanity_filter",
          body: jsonMap,
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return toggleProfanityFilter( status);
      }else if(response.statusCode == 200){
      }else{
        return "";
      }
    } catch (e) {
      throw e;
    }
  }

  Future unblockKrush( String relationId) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    Map<String, String> jsonMap = {
      'relationId': relationId,
    };
    try {
      final response = await _httpClient.post("$baseUrl/unblock_krush",
          body: jsonMap, headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return unblockKrush(newToken);
      }else if(response.statusCode == 200){
      }else{
        return "";
      }
    } catch (e) {
      throw e;
    }
  }

  

  Future<UserResponse> getUser( ) async {
  
          String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response =
          await _httpClient.get("$baseUrl/get_user", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getUser();
      }else if(response.statusCode == 200){
           return parseGetUser(response.body);
      }else{
        return null;
      }
   
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  static UserResponse parseGetUser(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      UserResponse result = UserResponse.fromJson(parsed);
      return result;
    } catch (e) {
    }
  }

  updateFreeAds() async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response =
          await _httpClient.get("$baseUrl/viewed_ad", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return updateFreeAds();
      }else if(response.statusCode == 200){
          final parsed = json.decode(response.body);
      return parsed;
      }else{
        return "";
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  getAdsCount() async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.get("$baseUrl/free_ads_remaining",
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getAdsCount();
      }else if(response.statusCode == 200){
         final parsed = json.decode(response.body);
      return parsed;
      }else{
        return "";
      }
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  notificationToggle( String url, bool status) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      "notificationFlag": status ? 1.toString() : 0.toString(),
    };
    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.post("$baseUrl/$url",
          body: jsonMap, headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return notificationToggle(url, status);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);
      return parsed;
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    Future<UserResponse> updateUser(
      String displayName,
      String email,
      String date,
      String country,
      String state,
      String city,
      String zip) async {
    Map<String, String> jsonMap = {
      "displayName": displayName,
      "dateOfBirth": date,
      "country": country,
      "state": state,
      "city": city,
      "zipcode": zip,
      "email": email
    };
          String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};

    try {
      final response = await _httpClient.post(
          "${baseUrl}/update_user_profile",
          body: jsonMap,
          headers: headers);
    
    if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return updateUser(displayName,email,date,country,state,city,zip);
      }else if(response.statusCode == 200){
        return parseUpdateUser(response.body);
      }else{
        return null;
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    static UserResponse parseUpdateUser(String responseBody) {
    try {
   
      final parsed = json.decode(responseBody);
      UserResponse result = UserResponse.fromJson(parsed);
      return result;
    } catch (e) {
     
    }
  }



    Future<ShippingAddress> listShippingAddresses( String url) async {
          String token = await UserSettingsManager.getUserToken();


    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.get(
          "${baseUrl}/${url}",
          headers: headers);
     
     if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return listShippingAddresses(url);
      }else if(response.statusCode == 200){
         final parsed = json.decode(response.body);
      ShippingAddress shippingAddress = ShippingAddress.fromJson(parsed);
      return shippingAddress;
      }else{
        return null;
      }
     
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    Future<BillingAddress> listBillingAddresses( String url) async {

          String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.get(
          "${baseUrl}/${url}",
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return listBillingAddresses( url);
      }else if(response.statusCode == 200){
       final parsed = json.decode(response.body);
      BillingAddress billingAddress = BillingAddress.fromJson(parsed);
      return billingAddress;
      }else{
        return null;
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  makePayment(double dollars, String paymentId) async {
    return getClientSecret(
        (dollars * 100).toInt().toString(),
        "USD",
        await UserSettingsManager.getStripeId(),
        paymentId);
  }

  getClientSecret( String amount, String currency,
      String customerId, String paymentId) async {
            String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      "amount": amount,
      "currency": currency,
      "stripeCustomerId": customerId,
      "paymentMethodId": paymentId,
      "offSession": true.toString(),
      "confirm": true.toString()
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
   
    try {
      final response = await _httpClient.post(
          "${baseUrl}/initiate_payment",
          body: jsonMap,
          headers: headers);
    if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getClientSecret( amount, currency,
       customerId,  paymentId);
      }else if(response.statusCode == 200){
       final parsed = json.decode(response.body);
      return parsed['status'];
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<bool> initCoinTransaction( int coins) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      'noOfCoins': coins.toString(),
      'transactionDetails': "Adding Coins",
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};

    try {
      final response = await _httpClient.post(
          "${baseUrl}/initiate_add_coins",
          body: jsonMap,
          headers: headers);
if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return initCoinTransaction( coins);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);
      return parsed['status'];
      }else{
        return false;
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<bool> addAddress(
      String type, String adressLine, String city, String state, String country, String zipcode) async {

                  String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      "addressLine1": adressLine,
      "addressLine2": "",
      "city": city,
      "state": state,
      "country": country,
      "zipcode": zipcode,
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
    String url = type == "Billing" ? "${baseUrl}/add_billing_address" : "${baseUrl}/add_shipping_address";
   
    try {
      final response = await _httpClient.post(
          url,
          body: jsonMap,
          headers: headers);
 if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return addAddress( type,    adressLine,  city,  state,  country,  zipcode);
      }else if(response.statusCode == 200){
             final parsed = json.decode(response.body);
      return parsed['status'];
      }else{
        return false;
      }
 
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }



  sendContacts(List<ContactModel> blocked, List<ContactModel> unblocked) async {
String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    final ContactList contactList = ContactList(blocked,unblocked);


final String requestBody = json.encoder.convert(contactList); 


    try {
      final response = await _httpClient.post(

          "${baseUrl}/block_unblock_contacts",
          body: requestBody,
          headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return sendContacts(blocked, unblocked);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);

      Result result = Result.fromJson(parsed);
      if (result.status) {
        return true;
      } else {
        return result.message;
      }
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }

}

sendAllContacts(List<ContactModel> allContacts) async {
String token = await UserSettingsManager.getUserToken();
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    final AllContactsList allContactsList = AllContactsList(allContacts);


final String requestBody = json.encoder.convert(allContactsList); 
    try {
      final response = await _httpClient.post(

          "${baseUrl}/save_user_contacts",
          body: requestBody,
          headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return sendAllContacts(allContacts);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);

      Result result = Result.fromJson(parsed);
      if (result.status) {
        return true;
      } else {
        return result.message;
      }
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }

}

  Future<BlockedContacts> getBlockedContacts() async {
String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      var response ;
        response = await _httpClient.get("${baseUrl}/get_blocked_contacts", headers: headers);
if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getBlockedContacts();
      }else if(response.statusCode == 200){
           return parseBlockedContacts(response.body);
      }else{
        return null;
      }
   
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  
}

  Future<BlockedContacts> parseBlockedContacts(String responseBody) async{
    try {
  
      final parsed = json.decode(responseBody);
      BlockedContacts blockedContacts = BlockedContacts.fromJson(parsed);
      return blockedContacts;
    } catch (e) {
    }
  }

    getAvatars() async {

    try {
      final response = await _httpClient.get("${baseUrl}/get_avatars");
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getAvatars();
      }else if(response.statusCode == 200){
          return json.decode(response.body)['data']['avatars'];
      }else{
        return "";
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  sendGifts( int relationId, List gifts) async {
          String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    final GiftList giftList =
    GiftList(List<Gifts>.generate(gifts.length, (int index) {
  return Gifts(productId: gifts[index], quantity: 1);
}), relationId);


final String requestBody = json.encoder.convert(giftList); 
    try {
      final response = await _httpClient.post(
          "${baseUrl}/save_gift_order",
          body: requestBody,
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return sendGifts( relationId, gifts);
      }else if(response.statusCode == 200){
      final parsed = json.decode(response.body);

      Result result = Result.fromJson(parsed);
      if (result.status) {
        return true;
      } else {
        return result.message;
      }
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }

}

acceptGift( String orderId, String shippingAddressId) async {
          String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "Authorization": "bearer " + token
    };

        Map<String, String> jsonMap = {
      'orders': orderId,
      'shippingAddressId': shippingAddressId,
    };

    try {
      final response = await _httpClient.post(
          "${baseUrl}/accept_gifts",
          body: jsonMap,
          headers: headers);
      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return acceptGift( orderId, shippingAddressId);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);

      Result result = Result.fromJson(parsed);
      if (result.status) {
        return true;
      } else {
        return result.message;
      }
      }else{
        return "";
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }

}


        Future<RecievedGifts> getRecievedGifts() async {
                    String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      var response ;
        response = await _httpClient.get("${baseUrl}/gifts_received", headers: headers);

        if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getRecievedGifts();
      }else if(response.statusCode == 200){
       return parsereceivedGifts(response.body);
      }else{
        return null;
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    static RecievedGifts parsereceivedGifts(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Result result = Result.fromJson(parsed);
      if (result.status) {
        RecievedGifts gifts = RecievedGifts.fromJson(parsed);
        return gifts;
      } else {
        return null;
      }
    } catch (e) {
    }
  }

  static SentGifts parseSentGifts(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Result result = Result.fromJson(parsed);
      if (result.status) {
        SentGifts gifts = SentGifts.fromJson(parsed);
        return gifts;
      } else {
        return null;
      }
    } catch (e) {
    }
  }

          Future<RecievedGifts> getReceivedGift( String orderId) async {
                      String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      var response ;
        response = await _httpClient.get("${baseUrl}/gifts_received/${orderId}", headers: headers);

        if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getReceivedGift( orderId);
      }else if(response.statusCode == 200){
          return parsereceivedGifts(response.body);
      }else{
        return null;
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

            Future<SentGifts> getSentGift( String orderId) async {
                        String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      var response ;
        response = await _httpClient.get("${baseUrl}/gifts_sent/${orderId}", headers: headers);

        if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getSentGift( orderId);
      }else if(response.statusCode == 200){
        return parseSentGifts(response.body);
      }else{
        return null;
      }
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

      
        Future<SentGifts> getSentGifts() async {
                    String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      final response =
          await _httpClient.get("${baseUrl}/gifts_sent", headers: headers);
          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getSentGifts();
      }else if(response.statusCode == 200){
              return parseSentGifts(response.body);
      }else{
        return null;
      }

    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }
    Future<Result> rejectGift(
      String orderId) async {

                  String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    Map<String, String> jsonMap = {'orders': orderId};

    final finalJson = jsonEncode(jsonMap);
    try {
      final response = await _httpClient
          .post("${baseUrl}/reject_gifts", body: finalJson, headers: headers);

if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return rejectGift(orderId);
      }else if(response.statusCode == 200){
           Result result = Result.fromJson(json.decode(response.body));
      return result;
      }else{
        return null;
      }
   
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<Result> confirmPayment( String orderId, String shippingAddressId) async {

              String token = await UserSettingsManager.getUserToken();

        Map<String, String> headers = {
      "Authorization": "bearer " + token
    };

     Map<String, String> jsonMap = {
      'orderId': orderId,
      'billingAddressId': shippingAddressId,
    };
    try {
      final response = await _httpClient
          .post("${baseUrl}/payment_status", headers: headers, body: jsonMap);
if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return confirmPayment( orderId, shippingAddressId);
      }else if(response.statusCode == 200){
         Result result = Result.fromJson(json.decode(response.body));
      return result;
      }else{
        return null;
      }
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    Future<Result> addKrushRequestAction(
    String krushName,
    String chatName,
    String krushMobile,
    String krushMessage,
    String avatarName,
  ) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "Authorization": "Bearer " + token,
      'content-type': 'application/json'
    };
    Map<String, String> jsonMap = {
      'chatName': chatName,
      'krushFirstName': krushName,
      'krushMobileNumber': krushMobile,
      'krushMessage': krushMessage,
      'avatar': avatarName,
    };
    final finalJson = jsonEncode(jsonMap);
    try {
      final response = await _httpClient.post(
          "${baseUrl}/add_krush",
          body: finalJson,
          headers: headers);
          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return addKrushRequestAction(  
     krushName,
     chatName,
     krushMobile,
     krushMessage,
     avatarName,);
      }else{
        return parseKrushRequest(response.body);
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  static Result parseKrushRequest(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Result myUser = Result.fromJson(parsed);
      return myUser;
    } catch (e) {
    }
  }

    Future<Register> registerUserWithKrush(
    String krushNumberController,
      String krushName,
      String chatNameController,
      String krushCommentController,
      String userDisplayNameController,
      String genderController,
      String dobController,
      String avatarName
  ) async {

              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "Authorization": "bearer " + token
    };

    Map<String, String> jsonMap;
    if (krushNumberController != null) {
        jsonMap = {
          "gender": genderController,
          "dateOfBirth": dobController,
          "displayName": userDisplayNameController,
          "krushMobileNumber": krushNumberController,
          "krushMessage": krushCommentController,
          "chatName": chatNameController,
          "avatar": avatarName,
          "krushFirstName": krushName
        };
      } else {
        jsonMap = {
          "gender": genderController,
          "dateOfBirth": dobController,
          "displayName": userDisplayNameController,
        };
      }


    try {
      final response = await _httpClient.post(
          "${baseUrl}/update_user_with_krush",
          body: jsonMap,
          headers: headers);
          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return registerUserWithKrush(
           krushNumberController,
       krushName,
       chatNameController,
       krushCommentController,
       userDisplayNameController,
       genderController,
       dobController,
       avatarName
        );
      }else{
        return parseRegisterWithKrush(response.body);
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

   static Register parseRegisterWithKrush(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Register myUser = Register.fromJson(parsed);
      return myUser;
    } catch (e) {
    }
  }

       Future<RecieveRequest> getPendingRequest(String requestType) async {
                   String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      var response ;
      if(requestType == null){
      response =
          await _httpClient.get("${baseUrl}/request_received", headers: headers);
      }else{
      response =
          await _httpClient.get("${baseUrl}/request_received/$requestType", headers: headers);
      }
if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getPendingRequest( requestType);
      }else if(response.statusCode == 200){
        return parsesentReceiveRequest(response.body);
      }else{
        return null;
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

    static RecieveRequest parsesentReceiveRequest(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Result result = Result.fromJson(parsed);
      if (result.status) {
        RecieveRequest myUser = RecieveRequest.fromJson(parsed);
        return myUser;
      } else {
        return null;
      }
    } catch (e) {
    }
  }

          Future<SentRequest> getSentRequestAction() async {
                      String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    try {
      final response =
          await _httpClient.get("${baseUrl}/request_sent", headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getSentRequestAction();
      }else if(response.statusCode == 200){
         return parsesentRequest(response.body);
      }else{
        return null;
      }
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

   SentRequest parsesentRequest(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      Result result = Result.fromJson(parsed);
      if (result.status) {
        SentRequest myUser = SentRequest.fromJson(parsed);
        return myUser;
      } else {
        return null;
      }
    } catch (e) {
    }
  }

    Future<CoinAddingResponse> addCoinsAPI( int coins) async {
                String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      'noOfCoins': coins.toString(),
      'transactionDetails': "Adding Coins",
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.post(
          "${baseUrl}/add_coins",
          body: jsonMap,
          headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return addCoinsAPI( coins);
      }else if(response.statusCode == 200){
    return parseCoins(response.body);
      }else{
        return null;
      }
  
    } on SocketException {
      return Future.error("check your internet connection");
    } on http.ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  static CoinAddingResponse parseCoins(String responseBody) {
    try {
      final parsed = json.decode(responseBody);
      CoinAddingResponse result = CoinAddingResponse.fromJson(parsed);
      return result;
    } catch (e) {
    }
  }

    listPaymentMethods( String customerId) async {
             String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      "stripeCustomerId": customerId,
      "type": "card"
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.post(
          "${baseUrl}/payment_methods",
          body: jsonMap,
          headers: headers);
          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return listPaymentMethods( customerId);
      }else if(response.statusCode == 200){
          final parsed = json.decode(response.body);
      return parsed;
      }else{
        return "";
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<bool> attachPaymentMethos(
       String customerId, String paymentId) async {

                   String token = await UserSettingsManager.getUserToken();

    Map<String, String> jsonMap = {
      "stripeCustomerId": customerId,
      "paymentId": paymentId
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};
    try {
      final response = await _httpClient.post(
          "${baseUrl}/attach_payment_method",
          body: jsonMap,
          headers: headers);
   if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return attachPaymentMethos( customerId, paymentId);
      }else if(response.statusCode == 200){
        final parsed = json.decode(response.body);
      return parsed['status'];
      }else{
        return false;
      }
    
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  
  Future<Result> revokeRequest(int relationId, String uri) async {
              String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    Map<String, String> jsonMap = {'relationId': relationId.toString()};

    final finalJson = jsonEncode(jsonMap);
    try {
      final response = await _httpClient
          .post(uri, body: finalJson, headers: headers);

          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return revokeRequest(relationId, uri);
      }else if(response.statusCode == 200){
        return parseRequestActions(response.body);
      }else{
        return null;
      }
      
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<Result> requestActions(
      int relationId, String uri) async {
                  String token = await UserSettingsManager.getUserToken();

    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "bearer " + token
    };

    Map<String, String> jsonMap = {'relationId': relationId.toString()};

    final finalJson = jsonEncode(jsonMap);
    try {
      final response = await _httpClient
          .post(uri, body: finalJson, headers: headers);


          if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return requestActions(relationId,  uri);
      }else if(response.statusCode == 200){
           return parseRequestActions(response.body);
      }else{
        return null;
      }
   
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  static Result parseRequestActions(String responseBody) {
    try {
      final parsed = json.decode(responseBody);

      Result myUser = Result.fromJson(parsed);
      return myUser;
    } catch (e) {
    }
  }

    Future<Result> addSubscription(String subscriptionFlag, String transactionId,
      String transactionDate) async {
    String token = await UserSettingsManager.getUserToken();
    Map<String, String> jsonMap;

    if (transactionId != null) {
      if (transactionDate != null) {
        jsonMap = {
          "subscriptionFlag": subscriptionFlag,
          "transactionId": transactionId,
          "transactionDate": SubscriptionRepository.getRenewalTimeString(transactionDate)
        };
      } else {
        jsonMap = {
          "subscriptionFlag": subscriptionFlag,
          "transactionId": transactionId
        };
      }
    } else {
      if (transactionDate != null) {
        jsonMap = {
          "subscriptionFlag": subscriptionFlag,
          "transactionDate": SubscriptionRepository.getRenewalTimeString(transactionDate)
        };
      } else {
        jsonMap = {"subscriptionFlag": subscriptionFlag};
      }
    }

    Map<String, String> headers = {"Authorization": "bearer " + token};

    try {
      final response = await Constants.httpClient.post(
          "${ApiClient.apiClient.baseUrl}/subscribed",
          body: jsonMap,
          headers: headers);

      if(response.statusCode == 401){
         String newToken = await getRefreshToken();
        return addSubscription(subscriptionFlag,  transactionId, transactionDate);
      }else{
              Result result = Result.fromJson(json.decode(response.body));
              return result;
      }

    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future getVerificationDataJson(String verificationDataString) async {
    String token = await UserSettingsManager.getUserToken();
    Map<String, String> jsonMap = {
      "receiptString": verificationDataString,
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};

    try {
      final response = await Client().post(
          "${ApiClient.apiClient.baseUrl}/verify_itunes_receipt",
          body: jsonMap,
          headers: headers);
        
      if(response.statusCode == 401){
         String newToken = await getRefreshToken();
        return getVerificationDataJson(verificationDataString);
      }else{
              return json.decode(response.body);
      }
     
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }

  Future<String>  getGifts() async {

    try {
      final response = await _httpClient.get("${ApiClient.apiClient.baseUrl}/get_gifts_for_app");

      if(response.statusCode == 401){
        String newToken = await getRefreshToken();
        return getGifts();
      }else{
        return response.body;
      }
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  }
}
