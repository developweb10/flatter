import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/bottom_nav_counters_bloc/bottom_nav_counters_bloc.dart';
import 'package:krushapp/bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import 'package:krushapp/bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'package:krushapp/model/blocked_conversation_model.dart';
import 'package:krushapp/model/message_model.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import 'package:krushapp/repositories/chat_messages_repository.dart';
import 'package:krushapp/utils/hero_dialog_route.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:krushapp/utils/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart';
import '../../model/chat_conversation_model.dart';
import '../../model/user_model.dart';
import '../pages/chat_screen.dart';
import '../../utils/time_helper.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RecentChatState();
  }
}

class _RecentChatState extends State<RecentChats>
    with AutomaticKeepAliveClientMixin<RecentChats>, TickerProviderStateMixin {
  ChatConversationsBloc conversationsBloc = ChatConversationsBloc();

  TextEditingController chatSearchController = TextEditingController();
  String searchQuery = '';

  AnimationController _animationController;

  Function wp;
  String userId;
  String userName = '';
  int toView = 0;
  String adLink = '';
  @override
  bool get wantKeepAlive => true;

  void _handleLoad(String value) {
    setState(() {
      toView = 1;
    });
  }

  getLink() {
    setState(() {
      adLink = AdsRepository.getNewAd();
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        vsync: this,
        duration: const Duration(milliseconds: 250));
    Future.delayed(Duration(milliseconds: 10), () {
      UserSettingsManager.getUserID().then((value) => userId = value);
      UserSettingsManager.getUserName().then((value) => setState(() {
            this.userName = value;
          }));
      getLink();
      conversationsBloc.add(GetUserConversations());
      chatSearchController.addListener(() {
        setState(() {
          searchQuery = chatSearchController.text;
        });
      });
    });
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 100,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                child: Center(
                  child: Container(
                    height: 44,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Center(
                      child: TextField(
                        controller: chatSearchController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search....',
                            hintStyle: TextStyle(color: Colors.white)),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 40, right: 40, top: 16),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.26),
                              offset: Offset(0, 5),
                              blurRadius: 10)
                        ],
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFfe4a49), Color(0xFFfff6060)])),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 35, left: 25, bottom: 25),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: BlocBuilder(
                    cubit: conversationsBloc,
                    builder: (context, state) {
                      if (state is ChatConversationsLoaded) {
                        return ValueListenableBuilder(
                          builder: (context, box, child) {
                            box = box as Box<ChatsConversationModel>;

                            int unreadConversations = 0;

                            for (var element in box.values.toList()) {
                              if (isMessageSeen(element)) {
                                unreadConversations = unreadConversations + 1;
                              }
                            }

                            context.bloc<BottomNavCountersBloc>().add(
                                UpdateCountersEvent(
                                    chatsCounter: unreadConversations));

                            var searchList = searchQuery.isNotEmpty
                                ? (box as Box<ChatsConversationModel>)
                                    .values
                                    .toList()
                                    .where((element) =>
                                        element.chatName.contains(searchQuery))
                                    .toList()
                                : null;

                            if ((box as Box<ChatsConversationModel>)
                                .values
                                .isEmpty) {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 8),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/images/icons/chats_empty.png'),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Hello $userName! \nyou\'ve got no messages or Krushes!',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          FlatButton(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          23)),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/AddKrushPage',
                                                    arguments: BlocProvider.of<
                                                            KrushSentBloc>(
                                                        context));
                                              },
                                              child: Text(
                                                'Tap to add Krush',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }

                            return AnimationLimiter(
                              child: searchQuery.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: searchList.length,
                                      itemBuilder: (context, index) {
                                        var conversation = searchList[index];
                                        var format =
                                            DateFormat('yyyy-MM-dd HH:mm:ss');
                                        DateTime date = format
                                            .parse(conversation.updatedAt, true);
                                        DateTime today = DateTime.now();
                                        DateTime todayDate = DateTime(
                                            today.year, today.month, today.day);
                                        DateTime yesterdayDate = todayDate
                                            .subtract(Duration(days: 1));

                                        // var dateFormat = DateFormat('dd/MM/yy');
                                        // var dateString;
                                        // if (date.day == todayDate.day &&
                                        //     date.month == todayDate.month &&
                                        //     date.year == todayDate.year) {
                                        //   dateString = 'Today';
                                        // } else if (date.day ==
                                        //         yesterdayDate.day &&
                                        //     date.month == yesterdayDate.month &&
                                        //     date.year == yesterdayDate.year) {
                                        //   dateString = 'Yesterday';
                                        // } else
                                        //   dateString = dateFormat.format(date.toLocal());
                                        return buildListItem(index, context,
                                            box, conversation, date.toLocal());
                                      })
                                  : ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: box.length,
                                      itemBuilder: (context, index) {
                                        var conversation =
                                            (box as Box<ChatsConversationModel>)
                                                .getAt(index);
                                        var format =
                                            DateFormat('yyyy-MM-dd HH:mm:ss');
                                        DateTime date = format.parse(
                                            conversation.lastMessage.time, true);
                                        DateTime today = DateTime.now();
                                        DateTime todayDate = DateTime(
                                            today.year, today.month, today.day);
                                        DateTime yesterdayDate = todayDate
                                            .subtract(Duration(days: 1));

                                        // var dateFormat = DateFormat('dd/MM/yy');
                                        // var dateString;
                                        // if (date.day == todayDate.day &&
                                        //     date.month == todayDate.month &&
                                        //     date.year == todayDate.year) {
                                        //   dateString = 'Today';
                                        // } else if (date.day ==
                                        //         yesterdayDate.day &&
                                        //     date.month == yesterdayDate.month &&
                                        //     date.year == yesterdayDate.year) {
                                        //   dateString = 'Yesterday';
                                        // } else
                                        //   dateString = dateFormat.format(date.toLocal());

                                        return buildListItem(index, context,
                                            box, conversation, date.toLocal());
                                      }),
                            );
                          },
                          valueListenable: Hive.box<ChatsConversationModel>(
                                  'conversationsBox')
                              .listenable(),
                        );
                      } else if (state is ChatConversationsError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Error Fetching Conversations'),
                              SizedBox(
                                height: 8,
                              ),
                              RaisedButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                    conversationsBloc
                                        .add(GetUserConversations());
                                  })
                            ],
                          ),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        );
                    }),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder(
                cubit: conversationsBloc,
                builder: (context, state) {
                  if (state is ChatConversationsLoaded &&
                      state.blockedConversations.isNotEmpty) {
                    return ValueListenableBuilder(
                        valueListenable: Hive.box<BlockedConversationModel>(
                                'blockedConversationsBox')
                            .listenable(),
                        builder: (context, box, child) {
                          if (box.length != 0)
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 16),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: Theme.of(context).primaryColor,
                                  )),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text('Blocked'),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: Theme.of(context).primaryColor,
                                  )),
                                ],
                              ),
                            );
                          else
                            return Container();
                        });
                  } else
                    return Container();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: BlocBuilder(
                    cubit: conversationsBloc,
                    builder: (context, state) {
                      if (state is ChatConversationsLoaded) {
                        return ValueListenableBuilder(
                          builder: (context, box, child) {
                            box = box as Box<BlockedConversationModel>;

                            return AnimationLimiter(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    var blockedConversation =
                                        (box as Box<BlockedConversationModel>)
                                            .getAt(index);
                                    var format =
                                        DateFormat('yyyy-MM-dd HH:mm:ss');
                                    DateTime date = format
                                        .parse(blockedConversation.updatedAt, true);
                                    DateTime today = DateTime.now();
                                    DateTime todayDate = DateTime(
                                        today.year, today.month, today.day);
                                    DateTime yesterdayDate =
                                        todayDate.subtract(Duration(days: 1));

                                    // var dateFormat = DateFormat('dd/MM/yy');
                                    // var dateString;
                                    // if (date.day == todayDate.day &&
                                    //     date.month == todayDate.month &&
                                    //     date.year == todayDate.year) {
                                    //   dateString = 'Today';
                                    // } else if (date.day == yesterdayDate.day &&
                                    //     date.month == yesterdayDate.month &&
                                    //     date.year == yesterdayDate.year) {
                                    //   dateString = 'Yesterday';
                                    // } else
                                    //   dateString = dateFormat.format(date.toLocal());

                                    return buildBlockedListItem(index, context,
                                        box, blockedConversation, date.toLocal());
                                  }),
                            );
                          },
                          valueListenable: Hive.box<BlockedConversationModel>(
                                  'blockedConversationsBox')
                              .listenable(),
                        );
                      } else
                        return Container();
                    }),
              ),
            )
          ],
        ));
  }

  cacheNewUnreadMessages(ChatsConversationModel conversationModel) async {
    var token = await UserSettingsManager.getUserToken();
    Box<Message> _messagesBox =
        await Hive.openBox('messages_${conversationModel.id.toString()}');
    if (!_messagesBox.values.toList().contains(conversationModel.lastMessage)) {
      locator<ChatMessagesRepository>()
          .getInitialMessagesFromApi(conversationModel.id.toString());
    }
  }

  AnimationConfiguration buildListItem(int index, BuildContext context, box,
      ChatsConversationModel conversation, DateTime date) {
    if (conversation.lastMessage.unread != null &&
        conversation.lastMessage.unread &&
        userId != null &&
        conversation.lastMessage.senderId.toString() != userId) {
      cacheNewUnreadMessages(conversation);
    }
    String messageText = '';
    if (conversation.lastMessage.type != null &&
        conversation.lastMessage.type == 'reveal') {
      if (conversation.id.toString() ==
          conversation.lastMessage.senderId.toString()) {
        messageText = 'Your Krush is Revealed';
      } else
        messageText = 'You have revealed yourself';
    } else if (conversation.lastMessage.image != null) {
      messageText = '📷 Image';
    } else {
      messageText = conversation.lastMessage.text ?? '';
    }
    if (conversation.lastMessage.type != null &&
        conversation.lastMessage.type.substring(0, 4) == 'gift') {
      if (conversation.id.toString() ==
          conversation.lastMessage.senderId.toString()) {
        messageText = '🎁 You have received a gift';
      } else
        messageText = '🎁 You sent a gift';
    }

    return AnimationConfiguration.staggeredList(
      duration: Duration(milliseconds: 600),
      delay: Duration(milliseconds: 100),
      position: index,
      child: SlideAnimation(
        verticalOffset: 500,
        child: FadeInAnimation(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: isMessageSeen(conversation)
                        ? Theme.of(context).primaryColor.withOpacity(0.2)
                        : null),
                // padding: EdgeInsets.symmetric(
                //     horizontal: wp(5),
                //     vertical: wp(2.5)),
                child: ListTile(
                  onTap: () async {
                    await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChatScreen(
                        user: User(
                          id: box.getAt(index).id,
                          displayName: box.getAt(index).chatName,
                        ),
                        requestData: box.getAt(index),
                      );
                    }));
                    conversationsBloc.add(GetUserConversations());
                  },
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: wp(5), vertical: wp(2.5)),
                  leading: InkWell(
                    onTap: () async {
                      String token = await UserSettingsManager.getUserToken();
                        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewRouteWrapper(
                  imageProvider: CachedNetworkImageProvider(
                                        box.getAt(index).avatar ?? '',
                                      ),
                  tag: "imageTag"+index.toString(),
                  title: box.getAt(index).chatName ?? '',
                  relationId: box.getAt(index).relationId.toString(),
                  token: token,
                  hasRevealed: box.getAt(index).hasRevealed
                ),
              ),
            );
                    },
                    child: Hero(
              tag: "imageTag"+index.toString(),
              child: CircleAvatar(
                      radius: 32,
                      child:  CachedNetworkImage(
                          imageUrl: box.getAt(index).avatar ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
    //                             child: PhotoView(
    //   imageProvider: imageProvider,
    // )
                              ))),
            ), 
                  ) ,
                  title: Text(
                    '${box.getAt(index).chatName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    messageText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // (conversation.lastMessage.unread != null &&
                      //         conversation.lastMessage.unread &&
                      //         userId != null &&
                      //         conversation.lastMessage.senderId.toString() !=
                      //             userId)
                      isMessageSeen(conversation)
                          ? Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                conversation.unreadMessages.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Offstage(),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        conversationTimestamp(date),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF3F4F9),
              ),
              BlocBuilder(
                  cubit: context.bloc<AdsBloc>(),
                  builder: (context, state) {
                    if (state is ToShowAd) {
                      if (state.toShow) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            index % 4 == 0
                                ? adLink != null
                                    ? Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10,
                                                bottom: 20.0,
                                                left: 20),
                                            child: Container(
                                                height: toView == 1 ? 50 : 1,
                                                child: WebView(
                                                  initialUrl:
                                                      Uri.dataFromString(adLink,
                                                              mimeType:
                                                                  'text/html')
                                                          .toString(),
                                                  // initialUrl: '',

                                                  javascriptMode: JavascriptMode
                                                      .unrestricted,
                                                  onPageFinished: _handleLoad,

                                                  navigationDelegate:
                                                      (NavigationRequest
                                                          request) {
                                                    launch(request.url);
                                                    return NavigationDecision
                                                        .prevent;
                                                  },
                                                )),
                                          )
                                        ],
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(
                                            bottom: 10.0, top: 10),
                                        child: AdmobBanner(
                                          adUnitId:
                                              AdsRepository.getBannerAdUnitId(),
                                          adSize: AdmobBannerSize.BANNER,
                                          listener: (AdmobAdEvent event,
                                              Map<String, dynamic> args) {},
                                          onBannerCreated:
                                              (AdmobBannerController
                                                  controller) {},
                                        ),
                                      )
                                : Container(),
                            index % 4 == 0 && (toView == 1 || adLink == null)
                                ? Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Color(0xFFF3F4F9),
                                  )
                                : Container(),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  AnimationConfiguration buildBlockedListItem(int index, BuildContext context,
      box, BlockedConversationModel conversation, DateTime date) {
    return AnimationConfiguration.staggeredList(
      duration: Duration(milliseconds: 600),
      delay: Duration(milliseconds: 100),
      position: index,
      child: SlideAnimation(
        verticalOffset: 500,
        child: FadeInAnimation(
          child: Column(
            children: [
              Container(
                foregroundDecoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.3)),
                child: ListTile(
                  onTap: () async {
                    String userId = await UserSettingsManager.getUserID();
                    if (userId == conversation.blockedBy) {
                      _animationController.forward();
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return getUnblockDialog(context, conversation);
                        },
                      );
                      if (response != null && response)
                        conversationsBloc.add(GetUserConversations());
                    } else
                      toast(
                          'You have been blocked by ${conversation.chatName}');
                  },
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: wp(5), vertical: wp(2.5)),
                  leading: CircleAvatar(
                      radius: 32,
                      child: CachedNetworkImage(
                          imageUrl: box.getAt(index).avatar ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ))),
                  title: Text(
                    '${box.getAt(index).chatName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    conversationTimestamp(date),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF3F4F9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUnblockDialog(
      BuildContext context, BlockedConversationModel conversationModel) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return ScaleTransition(
            scale: _animationController,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'Unblock ${conversationModel.chatName}?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.green,
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            ProgressBar.client.showProgressBar(context);
                            
                            await ApiClient.apiClient.unblockKrush(
                               conversationModel.relationId.toString());
                            ProgressBar.client.dismissProgressBar();
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            'Unblock',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isMessageSeen(ChatsConversationModel conversation) {
    return (conversation.unreadMessages != null &&
        conversation.unreadMessages > 0 &&
        conversation.lastMessage.senderId.toString() != userId);
    // return (conversation.unreadMessages != null &&
    //     conversation.unreadMessages > 0);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
