import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../../services/chat_service.dart';
import '../../widgets/news_feeds.dart';
import '../../../utils/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Function wp;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int indexTab = 0;
  String token;

  String pLAY_STORE_URL = '';

  ChatConversationsBloc conversationsBloc = ChatConversationsBloc();
  final ChatService chatService = locator<ChatService>();

  String adLink = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    if (Platform.isIOS) iOSPermission();
    chatService.receiveMessages();

    super.initState();
  }

  @override
  void dispose() {
    chatService.disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void iOSPermission() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;

    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0), // here the desired height
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFfe4a49), Color(0xFFfff6060)
                        // Color(0xFFff6060),
                        // Color(0xFFff6060),
                      ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: wp(25),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ListView.builder(
                            // padding: EdgeInsets.only(top: 2),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(wp(1)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: wp(7),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.redAccent,
                                                size: 40,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                index = index - 1;
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.all(wp(1)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          child: CircleAvatar(
                                              backgroundColor: Colors.black54,
                                              radius: wp(7),
                                              child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                        width: 80.0,
                                                        height: 80.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ))),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ))
                  ],
                ))),
        body: NewsFeeds(),);
  }
}
