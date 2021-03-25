

import 'package:krushapp/app/api_dio.dart';

import '../app/api.dart';
import '../model/sent_gifts.dart';
import '../model/recieved_gifts.dart';
import '../model/result.dart';



class GiftRepository {

  
sendGifts( int relationId, List gifts) async {

    return await ApiClient.apiClient.sendGifts( relationId, gifts);

}

acceptGift( String orderId, String shippingAddressId) async {

    return await ApiClient.apiClient.acceptGift( orderId, shippingAddressId);

}


        Future<RecievedGifts> getRecievedGifts() async {
    return await ApiClient.apiClient.getRecievedGifts();
  }

    static RecievedGifts parsereceivedGifts(String responseBody) {
return ApiClient.parsereceivedGifts(responseBody);
  }

          Future<RecievedGifts> getReceivedGift( String orderId) async {
 return await ApiClient.apiClient.getReceivedGift(orderId);
  }

            Future<SentGifts> getSentGift( String orderId) async {
    return await ApiClient.apiClient.getSentGift( orderId);
  }
        Future<SentGifts> getSentGifts() async {
    return await ApiClient.apiClient.getSentGifts();

  }

 

    Future<Result> rejectGift(
      String orderId, ) async {
           return await ApiClient.apiClient.rejectGift(orderId);

  }

  Future<Result> confirmPayment( String orderId, String shippingAddressId) async {
    
             return await ApiClient.apiClient.confirmPayment( orderId, shippingAddressId);

}
}