import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../../services/chat_service.dart';
import '../../widgets/recent_chats.dart';
import '../../../utils/service_locator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage>
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setOffline();
    } else if (state == AppLifecycleState.resumed) {
      setOnline();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setUserStatus();
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
        .listen((IosNotificationSettings settings) {
    });
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
   
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Theme.of(context).primaryColor,

        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RecentChats(),
          ],
        ));
  }

  setUserStatus() async {
    String userId = await UserSettingsManager.getUserID();
    var database = FirebaseDatabase.instance;
    var databaseRef = database.reference().child('status').child(userId);
    var isOfflineForDatabase = {
      'state': "offline",
      'last_changed': ServerValue.timestamp,
    };

    database.reference().child('.info/connected').onValue.listen((event) {
      if (event.snapshot.value == false) {
        return;
      }

      databaseRef.onDisconnect().set(isOfflineForDatabase).then((value) {
        setOnline();
      });
    });
  }

  setOnline() async {
    String userId = await UserSettingsManager.getUserID();
    var database = FirebaseDatabase.instance;
    var databaseRef = database.reference().child('status').child(userId);
    var isOnlineForDatabase = {
      'state': "online",
      'last_changed': ServerValue.timestamp,
    };
    databaseRef.set(isOnlineForDatabase);
  }

  setOffline() async {
    String userId = await UserSettingsManager.getUserID();
    var database = FirebaseDatabase.instance;
    var databaseRef = database.reference().child('status').child(userId);
    var isOfflineForDatabase = {
      'state': "offline",
      'last_changed': ServerValue.timestamp,
    };
    databaseRef.set(isOfflineForDatabase);
  }
}
