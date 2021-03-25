import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:krushapp/bloc/gift_recieved_bloc/gift_recieved_bloc_bloc.dart' as received_gift;
import 'package:krushapp/bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart' as sent_gift;
import '../bloc/krush_recieved_bloc/krush_recieved_bloc_bloc.dart'
    as accept_request;
import '../bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart'
    as sent_request;
import '../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  accept_request.KrushRequestBloc krushRequestBloc;
  ChatConversationsBloc conversationsBloc = ChatConversationsBloc();
  sent_request.KrushSentBloc krushsentBloc;
  Function handlePageChange;
  received_gift.GiftRecievedBloc giftRecievedBloc = received_gift.GiftRecievedBloc();
  sent_gift.GiftSentBloc giftSentBloc = sent_gift.GiftSentBloc();

  NotificationService(this.krushRequestBloc, this.krushsentBloc, this.handlePageChange, this.giftRecievedBloc, this.giftSentBloc) {
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      String event;
      if (Platform.isIOS) {
        event = message['event'];
      } else
        event = message['data']['event'];


      if (event == "new_krush") {
         this.krushRequestBloc.add(accept_request.KrushRequestListChanged());
      } else if (event == "accepted_request") {
         conversationsBloc.add(GetUserConversations());
         this.krushsentBloc.add(sent_request.KrushSentListChanged());
      } else if (event == "accepted_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "rejected_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "sent_gift") {
           giftRecievedBloc.add(received_gift.GiftsListChanged());
      } else {
          await conversationsBloc.add(GetUserConversations());
      }
    }, onLaunch: (Map<String, dynamic> message) async {
      String event;
      if (Platform.isIOS) {
        event = message['event'];
      } else
        event = message['data']['event'];
      if (event == "new_krush") {
         this.krushRequestBloc.add(accept_request.KrushRequestListChanged());
        this.handlePageChange(1);
      } else if (event == "accepted_request") {
         conversationsBloc.add(GetUserConversations());
         this.krushsentBloc.add(sent_request.KrushSentListChanged());
      }  else if (event == "accepted_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "rejected_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "sent_gift") {
           giftRecievedBloc.add(received_gift.GiftsListChanged());
      }  else {
          await conversationsBloc.add(GetUserConversations());

      }
    }, onResume: (Map<String, dynamic> message) async {
      String event;
      if (Platform.isIOS) {
        event = message['event'];
      } else
        event = message['data']['event'];
      if (event == "new_krush") {
         this.krushRequestBloc.add(accept_request.KrushRequestListChanged());    
        this.handlePageChange(1);    
      } else if (event == "accepted_request") {    
         conversationsBloc.add(GetUserConversations());    
         this.krushsentBloc.add(sent_request.KrushSentListChanged());
      }  else if (event == "accepted_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "rejected_gift") {
           giftSentBloc.add(sent_gift.GiftSentListChanged());
      }else if (event == "sent_gift") {
           giftRecievedBloc.add(received_gift.GiftsListChanged());
      }  else {
          await conversationsBloc.add(GetUserConversations());
      }
    });
  }
}
