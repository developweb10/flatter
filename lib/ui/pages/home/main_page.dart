import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/ads_bloc/ads_bloc.dart';
import '../../dialogs/subscription_dialog.dart';
import '../../dialogs/update_dialog.dart';
import '../../../bloc/account_page_bloc/account_page_bloc.dart';
import '../../../bloc/bottom_nav_counters_bloc/bottom_nav_counters_bloc.dart';
import '../../../bloc/gift_recieved_bloc/gift_recieved_bloc_bloc.dart';
import '../../../bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import '../../../bloc/krush_active_bloc/krush_active_bloc.dart';
import '../../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../../bloc/krush_recieved_bloc/krush_recieved_bloc_bloc.dart';
import '../../../bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart';
import '../../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
import '../../../repositories/subscription_repository.dart';
import '../../../services/notification_service.dart';
import 'gift_store_page.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'krushes_page.dart';
import 'profile_page.dart';
import 'package:package_info/package_info.dart';

class MainScreen extends StatefulWidget {
  File imageFile;

  MainScreen({this.imageFile});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  PageController pageController = PageController(keepPage: true);

  String token;
  String displayName;
  String avatar;
  String email;
  String mobileNumber;
  String pLAY_STORE_URL = '';

  ChatConversationsBloc conversationsBloc = ChatConversationsBloc();
  SubscriptionRepository subscriptionRepository = SubscriptionRepository();
  KrushRequestBloc krushRequestBloc;
  KrushActiveBloc krushActiveBloc;
  KrushSentBloc krushsentBloc;
  NotificationService notificationService;
  SubscriptionBlocBloc subscriptionBlocBloc;
  GiftRecievedBloc giftRecievedBloc;
  GiftSentBloc giftSentBloc;
  AccountPageBloc accountPageBloc;

  versionCheck(context) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.buildNumber.trim().replaceAll(".", ""));
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    double newVersion;

    try {

      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();


      if(Platform.isAndroid){
              newVersion = double.parse(remoteConfig
          .getString('force_update_current_version_android')
          .trim()
          .replaceAll(".", ""));
      }else if(Platform.isIOS){
              newVersion = double.parse(remoteConfig
          .getString('force_update_current_version_ios')
          .trim()
          .replaceAll(".", ""));
      }else{
        newVersion = 000;
      }

      if (newVersion > currentVersion) {
           showConfirmSheet();
      }


    } on FetchThrottledException catch (exception) {

    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  showConfirmSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        isDismissible : false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) =>
                UpdateDialog()));
  }

  void iOSPermission() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
  }

  handlePageChange(int pageNumber) {
    pageController.jumpToPage(pageNumber);
  }

  uploadProfilePic() {
    if (widget.imageFile != null) {
      context
          .bloc<AccountPageBloc>()
          .add(UpdateProfileImage(imageFile: widget.imageFile));
    }
  }

  checkTransactionDate() async {
    String expitydate = await UserSettingsManager.getSubscriptionExpiryDate();
    if (expitydate != null) {
      DateTime transactionDate = DateTime.parse(expitydate);

      if (transactionDate.isBefore(DateTime.now())) {
        context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription("0", null));
        UserSettingsManager.setSubsciptionStatus(0);
        context.bloc<SubscriptionBlocBloc>().add(ShowSubsciptionDialog());
      }
    } else {
      context.bloc<SubscriptionBlocBloc>().add(CheckToShowSubsciptionDialog());
    }

    context.bloc<AdsBloc>().add(CheckToShowAd());
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) iOSPermission();
    versionCheck(context);
    checkTransactionDate();

    uploadProfilePic();
  }

  @override
  void didChangeDependencies() {
    giftSentBloc = context.bloc<GiftSentBloc>();
     giftSentBloc.add(GiftSentListChanged());
    giftRecievedBloc = context.bloc<GiftRecievedBloc>();
    giftRecievedBloc.add(GiftsListChanged());
    krushRequestBloc = context.bloc<KrushRequestBloc>();
    krushRequestBloc.add(KrushRequestListChanged());
    krushsentBloc = context.bloc<KrushSentBloc>();
    krushsentBloc.add(KrushSentListChanged());
    accountPageBloc = context.bloc<AccountPageBloc>();
    context.bloc<AccountPageBloc>().add(GetAllInfo());
    notificationService = new NotificationService(krushRequestBloc,
        krushsentBloc, handlePageChange, giftRecievedBloc, giftSentBloc);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BlocBuilder<BottomNavCountersBloc, BottomNavCountersState>(
        builder: (context, state) {
          if (state is BottomNavCountersUpdated) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
                handlePageChange(selectedIndex);
              },
              items: getBottomNavBarItems(
                  state.chatsCounter, state.krushesCounter, state.giftsCounter),
              showSelectedLabels: false,
              showUnselectedLabels: false,
            );
          } else
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
                handlePageChange(selectedIndex);
              },
              items: getBottomNavBarItems(0, 0, 0),
              showSelectedLabels: false,
              showUnselectedLabels: false,
            );
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SubscriptionBlocBloc, SubscriptionBlocState>(
            listener: (context, state) {
              if (state is ShowSubscriptionDialog) {
                Future.delayed(Duration(seconds: 2), () async {
                  // await Navigator.pushNamed(context, '/SubscriptionScreen',
                  //     arguments: {
                  //       'krushAddBloc': null,
                  //       'requestActionBloc': null,
                  //       'subscriptionBlocBloc': subscriptionBlocBloc,
                  //       'initStore': state.initStore
                  //     });
                  String transactionId =
                      await UserSettingsManager.getSubscriptionTransactionID();
                  showDialog(
                      context: context,
                      child: SubscriptionDialog(transactionId));
                });
              }
            },
          ),
          BlocListener<KrushRequestBloc, KrushRequestBlocState>(
            listener: (context, state) {
              if (state is KrushRequestSuccess) {
                int counter_krush = 0;
                counter_krush = state.recieveRequest == null
                    ? 0
                    : state.recieveRequest.data.requestReceived.length;
                context
                    .bloc<BottomNavCountersBloc>()
                    .add(UpdateCountersEvent(krushesCounter: counter_krush));
              }
            },
          ),
          BlocListener<GiftRecievedBloc, GiftRecievedBlocState>(
            listener: (context, state) {
              if (state is GiftReceivedSuccess) {
                int giftCounter = 0;
                if (state.recievedGifts != null) {
                  for (var element in state.recievedGifts.data.giftRecieved) {
                    if (element.hasAccepted == 'pending') {
                      giftCounter = giftCounter + 1;
                    }
                  }
                }

                context
                    .bloc<BottomNavCountersBloc>()
                    .add(UpdateCountersEvent(giftsCounter: giftCounter));
              }
            },
          ),
        ],
        child: Container(
            child: PageView(
          controller: pageController,
          children: [HomePage(),   ChatPage(), KrushesPage(), GiftStorePage(), ProfilePage()],
        )),
      ),
    );
  }

  getBottomNavBarItems(int chatsCounter, int krushesCounter, int giftsCounter) {
    return [
      BottomNavigationBarItem(
          label: '',
          icon: Container(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Image.asset(
              'assets/images/home_active.png',
              height: 24,
              width: 24,
              color: selectedIndex == 0
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          )),
      BottomNavigationBarItem(
          label: '',
          icon: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8, top: 12, right: 8),
                child: SvgPicture.asset(
                  'assets/svg/chat_icon.svg',
                  height: 24,
                  width: 24,
                  color: selectedIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
              chatsCounter > 0
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(offset: Offset(0, 4), blurRadius: 8)
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: Text(
                          chatsCounter.toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    )
                  : Offstage()
            ],
          )),
      BottomNavigationBarItem(
          label: '',
          icon: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SvgPicture.asset(
                  'assets/svg/krushin_logo.svg',
                  height: 24,
                  width: 24,
                  color: selectedIndex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
              krushesCounter > 0
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(offset: Offset(0, 4), blurRadius: 8)
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: Text(
                          krushesCounter.toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    )
                  : Offstage()
            ],
          )),
      BottomNavigationBarItem(
          label: '',
          icon: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SvgPicture.asset(
                  'assets/svg/gift_store_icon.svg',
                  height: 24,
                  width: 24,
                  color: selectedIndex == 3
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
              giftsCounter > 0
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(offset: Offset(0, 4), blurRadius: 8)
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: Text(
                          giftsCounter.toString(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    )
                  : Offstage()
            ],
          )),
      BottomNavigationBarItem(
          label: '',
          icon: Container(
            padding: EdgeInsets.only(left: 8, top: 8, right: 8),
            child: SvgPicture.asset(
              'assets/svg/profile_icon.svg',
              height: 24,
              width: 24,
              color: selectedIndex == 4
                  ? Theme.of(context).primaryColor
                  : Colors.black,
            ),
          )),
    ];
  }
}

// krushin_sub_9.95

// MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnursGKNuoyj1/dE8WWBrzFfT/k8vuH/X/XivE+T2W9p5QH64iqiJg9NeKJDtjzGWR9UW4ZqNK0IDyD+VYW+zQGCSJImabOpIhog8nNmJF01R0QL3VEKGlMUWCY/ypJ/LVU8AQ10xtO4cNMqtdZi2QvbZEJSRo6QnGM03GWbqqI9Fa2CGLNvEexzKp9JtSNWtmqf4O2puKIo+xAgAWN6xiL+8bk1zx2Kzpn6IgntJm4sDked6VqOo2340eqQyYHRyc/jJQce4/56yrOB1FNvA4/NAZ3Sp7g99b0re7g3kHWV8i98OA/snSBg6Es98JXaeYUlKOO+VQq8I7YAERd/kmQIDAQAB
