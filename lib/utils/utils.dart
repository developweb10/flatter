import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/model/chat_conversation_model.dart';

mHeight(double h) {
  return Container(
    height: h,
  );
}

mWidth(double h) {
  return Container(
    width: h,
  );
}

mFlex() {
  return Flexible(
    flex: 1,
    child: Container(),
  );
}

mFlexValue(int f) {
  return Flexible(
    flex: f,
    child: Container(),
  );
}

navigateTo(context, page) {
  debugPrint("---------$page");
  if (page == "HomePage") {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      ModalRoute.withName('/'),
    );
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

navigateWithAnimation(context, page) {
  Navigator.of(context).push(
    PageRouteBuilder<Null>(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: page,
                );
              });
        },
        transitionDuration: Duration(milliseconds: 600)),
  );
}

List<ChatsConversationModel> sortChats(
    List<ChatsConversationModel> conversations) {
  List<ChatsConversationModel> sortedConversations = conversations.toList();
  var format = DateFormat('yyyy-MM-dd HH:mm:ss');
  sortedConversations.sort((a, b) {
    var aDate = format.parse(a.lastMessage.time);
    var bDate = format.parse(b.lastMessage.time);
    return bDate.compareTo(aDate);
  });
  return sortedConversations;
}
