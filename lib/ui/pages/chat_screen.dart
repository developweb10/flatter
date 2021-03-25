import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/ui/pages/krush_reveal_page.dart';
import '../../app/api.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../bloc/chat_messages_bloc/chat_messages_bloc.dart';
import '../../model/chat_conversation_model.dart';
import '../../model/message_model.dart';
import '../../model/user_model.dart';
import '../../services/chat_service.dart';
import 'chat_image_page.dart';
import 'chat_settings_page.dart';
import '../../utils/service_locator.dart';
import '../../utils/utils.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'gifts/accept_gift_page.dart';
import 'gifts/confirm_gift_page.dart';
import 'gifts/gift_listing_page.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final ChatsConversationModel requestData;

  ChatScreen({this.user, this.requestData});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Function wp;
  String token;
  TextEditingController textEditingController = TextEditingController();
  ScrollController chatListController = ScrollController();
  String currentUserID;

  final ChatService chatService = locator<ChatService>();

  ChatMessagesBloc chatMessagesBloc = ChatMessagesBloc();

  Stream<bool> typingEventsStream;

  StreamSubscription typingEventsSubscription;

  Timer _timer;
  int _secondsDelay = 5;
  int _currentTimer = 5;
  bool userTyping = false;
  bool sendEvent = true;

  int _sendTypingEventTimerCount = 5;
  Timer _sendTypingEventTimer;

  int oldestMessageId;
  int latestMessageId;
  bool showEmojiPicker = false;
  var messageFieldFocusNode = FocusNode();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<DateTime, List<Message>> messagesMap;
  List<Message> messagesList;

  bool refreshState = true;

  File imageFile;
  GiphyGif gif;

  StreamSubscription userStatusSubscription;
  bool isUserOnline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initialize();
    // Hive.box('').listenable().
  }

  initialize() async {
    await Future.delayed(Duration(milliseconds: 500));
    checkUserStatus();
    UserSettingsManager.getUserID().then((value) {
      currentUserID = value;
      UserSettingsManager.getUserToken().then((t) {
        token = t;
        setChatListListener();
        chatMessagesBloc.add(GetMessages(userId: widget.user.id.toString()));
        Hive.openBox<Message>('messages_${widget.user.id}').then((box) {
          checkForUnreadMessages(box);
          if (box.length > 0) {
            oldestMessageId = box.getAt(box.length - 1).id;

            latestMessageId = box.getAt(0).id;
          }
        });

        typingEventsStream = chatService.listeningToMessagesOnChatScreen(
            widget.user.id.toString(), updateChatMessages, onNewMessage);
        textEditingController.addListener(() {
          if (textEditingController.text.isNotEmpty && sendEvent) {
            chatService.whisperTyping(widget.user.id.toString());
            startSendTypingEventTimer();
          }
        });
        typingEventsSubscription = typingEventsStream.listen((event) {
          if (event) {
            if (_timer != null && _timer.isActive)
              resetTimer();
            else
              startTimer();

            setState(() {
              userTyping = true;
            });
          } else {
            if (_timer != null && _timer.isActive) {
              _timer.cancel();
              _currentTimer = 0;
              setState(() {
                userTyping = false;
              });
            }
          }
        });
      });
    });

    messageFieldFocusNode.addListener(() {
      if (showEmojiPicker)
        setState(() {
          showEmojiPicker = false;
        });
    });

    // Future.delayed(Duration(milliseconds: 10), () {
    //   messageFieldFocusNode.requestFocus();
    // });
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: false,
        leading: Container(
          margin: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.displayName,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            isUserOnline
                ? Text(
                    'online',
                    style: TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.normal),
                  )
                : Offstage()
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[_buildGiftButton(context), _buildRevealButton()],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: BlocConsumer<ChatMessagesBloc, ChatMessagesState>(
                  cubit: chatMessagesBloc,
                  listener: (context, state) {
                    if (state is ChatMessagesLoaded) {
                      Hive.openBox<Message>('messages_${widget.user.id}')
                          .then((box) {
                        
                        if (box.length - 1 > 0) {
                          checkForUnreadMessages(box);
                          oldestMessageId = box.getAt(box.length - 1).id;
                          latestMessageId = box.getAt(0).id;
                        
                        }
                      });
                    } else if (state is OlderMessagesLoaded) {
                      Hive.openBox<Message>('messages_${widget.user.id}')
                          .then((box) {
                        checkForUnreadMessages(box);
                        oldestMessageId = box.getAt(box.length - 1).id;
                        latestMessageId = box.getAt(0).id;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatMessagesLoaded ||
                        state is OlderMessagesLoaded) {
                      if (state is ChatMessagesLoaded)
                        messagesList = state.messages;
                      //messagesMap = mapMessagesWithDates(messagesList);
                      return Stack(
                        children: [
                          CustomScrollView(
                            controller: chatListController,
                            reverse: true,
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 8,
                                ),
                              ),
                              SliverToBoxAdapter(
                                  child: userTyping
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 8,
                                            ),
                                            JumpingText(
                                              '···',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w900,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                                child: Text(
                                                    '${widget.user.displayName} is typing'))
                                          ],
                                        )
                                      : Offstage()),
                              SliverToBoxAdapter(
                                  child: ValueListenableBuilder(
                                valueListenable: Hive.box<Message>(
                                        'messages_${widget.user.id}')
                                    .listenable(),
                                builder: (context, value, child) {
                                  messagesList = value.values.toList();
                                  checkForUnreadMessages(value);
                                  return ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: messagesList.length,
                                      itemBuilder: (context, datesIndex) {
                                        final Message message =
                                            messagesList[datesIndex];
                                        final bool isMe =
                                            message.senderId.toString() ==
                                                currentUserID;
                                        return _buildMessage(
                                            messagesList, datesIndex, isMe);
                                      });
                                },
                              )),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 0,
                            left: 0,
                            child: Visibility(
                              visible: state is ChatConversationsLoading,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.circular(32)),
                                  child: Text('Updating Conversation...'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is ChatMessagesError) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text('Error Getting Messages'),
                            SizedBox(
                              height: 8,
                            ),
                            RaisedButton(
                              onPressed: () {
                                chatMessagesBloc.add(GetMessages(
                                    userId: widget.user.id.toString()));
                              },
                              child: Text('Retry'),
                            )
                          ],
                        ),
                      );
                    } else
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                  },
                ),
              ),
            ),
            _buildMessageComposer(),
            Container(
              height: (!isKeyboardVisible() && showEmojiPicker) ? null : 0,
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    height:
                        (!isKeyboardVisible() && showEmojiPicker) ? null : 0,
                    child: EmojiPicker(
                        bgColor: Colors.white,
                        buttonMode: ButtonMode.CUPERTINO,
                        onEmojiSelected: (emoji, category) {
                          textEditingController.text =
                              textEditingController.text + '${emoji.emoji}';
                        }),
                  ),
                  (!isKeyboardVisible() && showEmojiPicker)
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              IconButton(
                                  icon: Icon(Icons.backspace_rounded),
                                  color: Colors.grey,
                                  onPressed: () {
                                    if (textEditingController.text.isNotEmpty) {
                                      String text = textEditingController.text;
                                      text = text.characters.skipLast(1).string;
                                      textEditingController.text = text;
                                    }
                                  })
                            ],
                          ),
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewPadding.bottom,
                              right: 8,
                              left: 8),
                          color: Colors.white,
                        )
                      : Offstage(),
                ],
              ),
            ),
            (!isKeyboardVisible() && !showEmojiPicker)
                ? Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).viewPadding.bottom,
                  )
                : Offstage()
          ],
        ),
      ),
    );
  }

  startTimer() {
    const oneSec = const Duration(seconds: 1);
    _currentTimer = _secondsDelay;
    _timer = Timer.periodic(oneSec, (timer) {
      if (_currentTimer < 1) {
        timer.cancel();
        setState(() {
          userTyping = false;
        });
      } else {
        _currentTimer = _currentTimer - 1;
      }
    });
  }

  resetTimer() {
    _currentTimer = _secondsDelay;
  }

  startSendTypingEventTimer() {
    const oneSec = const Duration(seconds: 1);
    sendEvent = false;
    _sendTypingEventTimerCount = _secondsDelay;
    _sendTypingEventTimer = Timer.periodic(oneSec, (timer) {
      if (_sendTypingEventTimerCount < 1) {
        timer.cancel();

        sendEvent = true;
      } else {
        _sendTypingEventTimerCount = _sendTypingEventTimerCount - 1;
      }
    });
  }

  _buildMessage(
    List<Message> messages,
    int index,
    bool isMe,
  ) {
    Message message = messages[index];

    if (message.type != null && message.type == 'reveal') {
      String revealText = '';
      String buttonText;
      if (widget.user.id.toString() == message.senderId.toString()) {
        revealText = 'Your Krush is Revealed.';
        buttonText = 'View';
      } else
        revealText = 'You have revealed yourself.';
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Expanded(
                child: Divider(
              color: Theme.of(context).primaryColor,
            )),
            SizedBox(
              width: 16,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: revealText, style: TextStyle(color: Colors.black)),
              buttonText != null
                  ? TextSpan(
                      text: ' $buttonText',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => KrushRevealPage({
                                    'relationId': widget.requestData.relationId
                                        .toString(),
                                    'token': token
                                  })));
                        })
                  : TextSpan()
            ])),
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
    } else if (message.type != null && message.type.contains('gift')) {
      String orderId = message.type.substring(message.type.indexOf('/') + 1);
      String giftText = '';
      String buttonText;
      if (widget.user.id.toString() == message.senderId.toString()) {
        if (message.type.contains('sent_gift')) {
          // giftText = 'You sent a gift.';
          // buttonText = null;
        } else if (message.type.contains('received_gift')) {
          giftText = '🎁 ${widget.user.displayName} sent you a gift.';
          buttonText = "View Gift";
        } else if (message.type.contains('accepted_gift')) {
          giftText = 'Your gift has been accepted.';
          buttonText = 'Pay Now';
        } else if (message.type.contains('rejected_gift')) {
          giftText = 'Your gift has been rejected.';
          buttonText = null;
        }

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                color: Theme.of(context).primaryColor,
              )),
              SizedBox(
                width: 16,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: giftText, style: TextStyle(color: Colors.black)),
                buttonText != null
                    ? TextSpan(
                        text: " " + buttonText,
                        style: TextStyle(color: Colors.redAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            message.type.contains('accepted_gift')
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmGiftPage(
                                          fromChat: true,
                                          krushName: widget.user.displayName,
                                          orderId: orderId),
                                    ))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AcceptGiftPage(
                                            fromChat: true,
                                            krushName: widget.user.displayName,
                                            orderId: orderId)),
                                  );
                          })
                    : TextSpan()
              ])),
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
      } else {
        String orderId = message.type.substring(message.type.indexOf('/') + 1);

        if (message.type.contains('sent_gift')) {
          giftText = 'You sent a gift.';
        } else if (message.type.contains('received_gift')) {
          giftText = 'You sent a gift.';
          buttonText = null;
        } else if (message.type.contains('accepted_gift')) {
          giftText = 'You accepted the gift.';
        } else if (message.type.contains('rejected_gift')) {
          giftText = 'You rejected the gift.';
        }

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                color: Theme.of(context).primaryColor,
              )),
              SizedBox(
                width: 16,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: giftText, style: TextStyle(color: Colors.black)),
                buttonText != null
                    ? TextSpan(
                        text: " " + buttonText,
                        style: TextStyle(color: Colors.redAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AcceptGiftPage(
                                      fromChat: true,
                                      krushName: widget.user.displayName,
                                      orderId: orderId),
                                ));
                            //TODO navigate to gift screen
                          })
                    : TextSpan()
              ])),
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
      }
    }

    var timeString = '';
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');

    if (message.sending != null && message.sending) {
      message.isLiked = false;
      if (message.text == null) message.text = '';
    }

    if (message.text == null) {
      message.text = '';
    }
    DateTime dateTime = format.parse(message.time, (message.sending != null && message.sending) ? false : true);
    var timeFormat = DateFormat.jm();
    timeString = timeFormat.format(dateTime.toLocal());

    bool firstMessageLayout = false;
    bool lastMessageLayout = false;
    bool singleMessageLayout = false;

    bool showDateHeader = false;
    DateTime messageDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (index == messages.length - 1) {
      firstMessageLayout = true;
      showDateHeader = true;
    } else {
      Message nextMessage = messages[index + 1];
      // bool isNotTextOrImageMessage =
      //     nextMessage.type != null || (nextMessage.type nextMessage.type == 'image');

      DateTime nextMessageDateTime = format.parse(nextMessage.time);
      DateTime nextMessageDate = DateTime(nextMessageDateTime.year,
          nextMessageDateTime.month, nextMessageDateTime.day);
      showDateHeader = messageDate != nextMessageDate;
      firstMessageLayout = nextMessage.senderId != message.senderId ||
          showDateHeader ||
          isRevealorGiftMessage(nextMessage);
    }

    if (index == 0) {
      lastMessageLayout = true;
    } else {
      Message previousMessage = messages[index - 1];
      DateTime previousMessageDateTime = format.parse(previousMessage.time);
      DateTime previousMessageDate = DateTime(previousMessageDateTime.year,
          previousMessageDateTime.month, previousMessageDateTime.day);
      lastMessageLayout = previousMessage.senderId != message.senderId ||
          messageDate != previousMessageDate ||
          isRevealorGiftMessage(previousMessage);
    }
    if (messages.length == 1) {
      singleMessageLayout = true;
    } else if (index == 0) {
      Message nextMessage = messages[index + 1];
      DateTime nextMessageDateTime = format.parse(nextMessage.time);
      DateTime nextMessageDate = DateTime(nextMessageDateTime.year,
          nextMessageDateTime.month, nextMessageDateTime.day);
      singleMessageLayout = nextMessage.senderId != message.senderId ||
          messageDate != nextMessageDate ||
          isRevealorGiftMessage(nextMessage);
    } else if (index == messages.length - 1) {
      Message previousMessage = messages[index - 1];
      DateTime previousMessageDateTime = format.parse(previousMessage.time);
      DateTime previousMessageDate = DateTime(previousMessageDateTime.year,
          previousMessageDateTime.month, previousMessageDateTime.day);
      singleMessageLayout = previousMessage.senderId != message.senderId ||
          messageDate != previousMessageDate ||
          isRevealorGiftMessage(previousMessage);
    } else {
      Message nextMessage = messages[index + 1];
      DateTime nextMessageDateTime = format.parse(nextMessage.time);
      DateTime nextMessageDate = DateTime(nextMessageDateTime.year,
          nextMessageDateTime.month, nextMessageDateTime.day);
      Message previousMessage = messages[index - 1];
      DateTime previousMessageDateTime = format.parse(previousMessage.time);
      DateTime previousMessageDate = DateTime(previousMessageDateTime.year,
          previousMessageDateTime.month, previousMessageDateTime.day);
      singleMessageLayout = (nextMessage.senderId != message.senderId ||
              messageDate != nextMessageDate ||
              isRevealorGiftMessage(nextMessage)) &&
          (previousMessage.senderId != message.senderId ||
              messageDate != previousMessageDate ||
              isRevealorGiftMessage(previousMessage));
    }

    bool containsOnlyEmoji = message.text.replaceAll(
                RegExp(
                    '(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|[\ud83c[\ude01\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|[\ud83c[\ude32\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|[\ud83c[\ude50\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])'),
                '') ==
            '' &&
        message.text.length < 14;

    var borderRadius;
    if (singleMessageLayout) {
      borderRadius = BorderRadius.circular(18);
    } else if (firstMessageLayout) {
      borderRadius = isMe
          ? BorderRadius.only(
              topRight: Radius.circular(18.0),
              topLeft: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(4))
          : BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(4));
    } else if (lastMessageLayout) {
      borderRadius = isMe
          ? BorderRadius.only(
              topRight: Radius.circular(4.0),
              topLeft: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18))
          : BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(18));
    } else {
      borderRadius = isMe
          ? BorderRadius.only(
              topRight: Radius.circular(4.0),
              topLeft: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(4))
          : BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(4));
    }

    final Widget msg = Stack(
      children: <Widget>[
        InkWell(
          onLongPress: () {
            showMessageDeleteDialog(isMe, message);
          },
          onTap: (message.image != null && message.sending == null)
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return ChatImageScreen(message.id, message.image);
                      }));
                }
              : null,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            margin: EdgeInsets.only(
              top: firstMessageLayout ? 16.0 : 0.0,
              left: 8.0,
              right: 8.0,
              bottom: message.isLiked && isMe ? 12 : 1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  constraints: isMe && message.isLiked
                      ? BoxConstraints(minWidth: 105)
                      : null,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).primaryColor.withOpacity(
                            (message.sending != null && message.sending)
                                ? 0.5
                                : 1.0)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: borderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildMessagBubble(message, borderRadius, isMe,
                          containsOnlyEmoji, timeString),
                      message.image == null
                          ? Container(
                              padding: EdgeInsets.only(
                                  bottom: 8.0,
                                  right: isMe ? 8 : 16.0,
                                  left: isMe ? 16 : 8),
                              child: Text(
                                timeString,
                                textAlign: TextAlign.end,
                                // + ' ' + message.id.toString(),
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: 10.0,
                                ),
                              ),
                            )
                          : Offstage(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        message.isLiked && isMe
            ? Positioned(
                left: 16,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            color: Theme.of(context).primaryColor),
                      ]),
                  child: SvgPicture.asset(
                    'assets/svg/krushin_logo.svg',
                    color: Theme.of(context).primaryColor,
                    width: 18,
                    height: 18,
                  ),
                ),
              )
            : Offstage()
      ],
    );

    if (isMe) {
      return Column(
        children: [
          (showDateHeader)
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    getDateString(messageDate),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.3),
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Spacer(),
              (message.id == latestMessageId)
                  ? Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      child: AnimatedSize(
                        alignment: Alignment.topCenter,
                        vsync: this,
                        duration: Duration(milliseconds: 100),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              msg,
                              (message.unread != null && !message.unread)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('seen'),
                                    )
                                  : Offstage()
                            ],
                          ),
                        ),
                      ),
                    )
                  : msg,
            ],
          ),
        ],
      );
    }
    return Column(
      children: [
        (showDateHeader)
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(8),
                child: Text(
                  getDateString(messageDate),
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: msg),
            Container(
              child: IconButton(
                  onPressed: () {
                    chatService.likeMessage(
                        widget.user.id.toString(), message.id.toString());
                  },
                  icon: message.isLiked
                      ? SvgPicture.asset(
                          'assets/svg/krushin_logo.svg',
                          color: Theme.of(context).primaryColor,
                          width: 18,
                          height: 18,
                        )
                      : Image.asset(
                          'assets/images/icons/krushin_icon_outline.png',
                          height: 24,
                          width: 24,
                        )),
            ),
            Spacer()
          ],
        ),
      ],
    );
  }

  bool isRevealorGiftMessage(Message message) {
    return message.type != null &&
        (message.type == 'reveal' || message.type.contains('gift'));
  }

  Widget buildMessagBubble(Message message, borderRadius, bool isMe,
      bool containsOnlyEmoji, String timeString) {
    return Container(
      padding: message.image == null
          ? EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)
          : EdgeInsets.all(0),
      child: message.image != null
          ? (message.sending != null && message.sending)
              ? Container(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: borderRadius,
                              child: Image.file(File(message.image))),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: BackdropFilter(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: borderRadius,
                                  ),
                                ),
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              ),
                            ),
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                      (message.text != null && message.text.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: 8,
                                  right: isMe ? 8 : 0,
                                  left: isMe ? 0 : 8,
                                  bottom: 8),
                              child: Text(
                                message.text,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: containsOnlyEmoji ? 32 : 16.0,
                                ),
                              ),
                            )
                          : Offstage(),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(borderRadius: borderRadius),
                  padding: EdgeInsets.all(
                      (message.text != null && message.text.isNotEmpty)
                          ? 8
                          : 0),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: (message.text != null &&
                                    message.text.isNotEmpty)
                                ? BorderRadius.circular(18)
                                : borderRadius,
                            child: Hero(
                              tag: message.id,
                              child: CachedNetworkImage(
                                imageUrl: message.image,
                                placeholder: (context, url) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    ),
                                    width: 200,
                                    height: 150,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: isMe ? 0 : null,
                            left: isMe ? null : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16)),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(
                                  bottom: 8.0,
                                  right: isMe ? 8 : 16.0,
                                  left: isMe ? 16 : 8),
                              child: Text(
                                timeString,
                                textAlign: TextAlign.end,
                                // + ' ' + message.id.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      (message.text != null && message.text.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: 8,
                                  right: isMe ? 8 : 0,
                                  left: isMe ? 0 : 8,
                                  bottom: 8),
                              child: Text(
                                message.text,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                  fontSize: containsOnlyEmoji ? 32 : 16.0,
                                ),
                              ),
                            )
                          : Offstage(),
                    ],
                  ),
                )
          : Text(
              message.text,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: containsOnlyEmoji ? 32 : 16.0,
              ),
            ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 8, bottom: 8),
      constraints: BoxConstraints(minHeight: 70),
      child: AnimatedSize(
        alignment: Alignment.bottomCenter,
        vsync: this,
        duration: Duration(milliseconds: 250),
        child: Column(
          children: [
            buildPickedImageWidget(),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 16,
                                  bottom: 16 +
                                      MediaQuery.of(context)
                                          .viewPadding
                                          .bottom),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          'assets/svg/add_photo_icon.svg',
                                          color: Colors.black,
                                        ),
                                        iconSize: 32.0,
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          refreshState = false;
                                          try {
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            var file =
                                                await imagePicker.getImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (file != null) {
                                              try {
                                                setState(() {
                                                  imageFile = File(file.path);
                                                });
                                              } catch (e) {
                                              }
                                            }
                                          } on PlatformException catch (e) {
                                            if (e.code ==
                                                'photo_access_denied') {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Photo Access Denied'),
                                                    content: Text(
                                                        'Krushin requires photos access to set a profile picture.'),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text('Cancel')),
                                                      FlatButton(
                                                          onPressed: () {
                                                            AppSettings
                                                                .openAppSettings();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                              'Open Settings'))
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      Text('Gallery')
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.gif),
                                        iconSize: 40,
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          gif = await GiphyPicker.pickGif(
                                              context: context,
                                              apiKey:
                                                  'SY4iLlWygCP2XyaHfdnPtxMwtBLKnnC7');

                                          setState(() {});
                                        },
                                      ),
                                      Text('GIF')
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: 12,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextField(
                              minLines: 1,
                              maxLines: 6,
                              style: TextStyle(color: Colors.white),
                              controller: textEditingController,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.send,
                              focusNode: messageFieldFocusNode,
                              onSubmitted: (value) async {
                                if (imageFile != null) {
                                  var file = imageFile;

                                  setState(() {
                                    imageFile = null;
                                  });
                                  String message =
                                      (textEditingController.text.isNotEmpty)
                                          ? textEditingController.text
                                          : '';
                                  textEditingController.clear();
                                  if (showEmojiPicker) {
                                    setState(() {
                                      showEmojiPicker = false;
                                    });
                                    messageFieldFocusNode.requestFocus();
                                  }
                                  await chatService.sendMessage(
                                      message,
                                      widget.user.id.toString(),
                                      widget.requestData.relationId.toString(),
                                      imageFile: file);
                                  file.delete();
                                } else if (gif != null) {
                                  GiphyGif gif = this.gif;
                                  // GiphyImage.

                                  setState(() {
                                    this.gif = null;
                                  });
                                  String message =
                                      (textEditingController.text.isNotEmpty)
                                          ? textEditingController.text
                                          : '';
                                  textEditingController.clear();
                                  if (showEmojiPicker) {
                                    setState(() {
                                      showEmojiPicker = false;
                                    });
                                    messageFieldFocusNode.requestFocus();
                                  }
                                  await chatService.sendMessage(
                                    message,
                                    widget.user.id.toString(),
                                    widget.requestData.relationId.toString(),
                                    gifUrl: gif.images.original.url,
                                  );
                                } else if (textEditingController
                                    .text.isNotEmpty) {
                                  chatService.sendMessage(
                                    textEditingController.text,
                                    widget.user.id.toString(),
                                    widget.requestData.relationId.toString(),
                                  );
                                  textEditingController.clear();
                                  if (showEmojiPicker) {
                                    setState(() {
                                      showEmojiPicker = false;
                                    });
                                    messageFieldFocusNode.requestFocus();
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type Something',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: showEmojiPicker
                              ? Icon(Icons.keyboard)
                              : SvgPicture.asset(
                                  'assets/svg/insert_emoji_icon.svg'),
                          iconSize: 25.0,
                          color: Colors.white,
                          onPressed: () async {
                            if (!showEmojiPicker) {
                              FocusScope.of(context).unfocus();
                              await Future.delayed(Duration(milliseconds: 0));
                              setState(() {
                                showEmojiPicker = true;
                              });
                            } else {
                              setState(() {
                                showEmojiPicker = false;
                              });
                              messageFieldFocusNode.requestFocus();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset('assets/svg/send_message_icon.svg'),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () async {
                    if (imageFile != null) {
                      var file = imageFile;

                      setState(() {
                        imageFile = null;
                      });
                      String message = (textEditingController.text.isNotEmpty)
                          ? textEditingController.text
                          : '';
                      textEditingController.clear();
                      if (showEmojiPicker) {
                        setState(() {
                          showEmojiPicker = false;
                        });
                        messageFieldFocusNode.requestFocus();
                      }
                      await chatService.sendMessage(
                          message,
                          widget.user.id.toString(),
                          widget.requestData.relationId.toString(),
                          imageFile: file);
                      file.delete();
                    } else if (gif != null) {
                      GiphyGif gif = this.gif;
                      // GiphyImage.

                      setState(() {
                        this.gif = null;
                      });
                      String message = (textEditingController.text.isNotEmpty)
                          ? textEditingController.text
                          : '';
                      textEditingController.clear();
                      if (showEmojiPicker) {
                        setState(() {
                          showEmojiPicker = false;
                        });
                        messageFieldFocusNode.requestFocus();
                      }
                      await chatService.sendMessage(
                        message,
                        widget.user.id.toString(),
                        widget.requestData.relationId.toString(),
                        gifUrl: gif.images.original.url,
                      );
                    } else if (textEditingController.text.isNotEmpty) {
                      chatService.sendMessage(
                        textEditingController.text,
                        widget.user.id.toString(),
                        widget.requestData.relationId.toString(),
                      );
                      textEditingController.clear();
                      if (showEmojiPicker) {
                        setState(() {
                          showEmojiPicker = false;
                        });
                      }
                      messageFieldFocusNode.requestFocus();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPickedImageWidget() {
    if (imageFile != null)
      return Container(
          constraints: BoxConstraints(
            maxHeight: 300,
          ),
          margin: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 16),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                children: [
                  Image.file(imageFile),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              imageFile.delete();
                              setState(() {
                                imageFile = null;
                              });
                            }),
                      ),
                    ),
                  )
                ],
              )));
    else if (gif != null) {
      return Container(
          constraints: BoxConstraints(
            maxHeight: 300,
          ),
          margin: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 16),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                children: [
                  GiphyImage.original(
                    gif: gif,
                    placeholder: Container(
                      height: 200,
                      width: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                gif = null;
                              });
                            }),
                      ),
                    ),
                  )
                ],
              )));
    } else
      return Offstage();
  }

  _buildRevealButton() {
    return IconButton(
        icon: SvgPicture.asset('assets/svg/info_button.svg'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChatOptionsScreen(widget.requestData);
          }));
        });
  }

  _buildGiftButton(BuildContext context) {
    return IconButton(
        icon: SvgPicture.asset('assets/svg/gift_icon.svg'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GiftListingPage(widget.requestData.relationId)),
          );
        });
  }

  void setChatListListener() {
    chatListController.addListener(() {
      if (chatListController.offset >=
              chatListController.position.maxScrollExtent &&
          !chatListController.position.outOfRange) {
        chatMessagesBloc.add(GetOlderMessages(
            userId: widget.user.id.toString(),
            oldMessageId: oldestMessageId.toString()));
      }
    });
  }

  void updateChatMessages() async {
    Box<Message> box =
        await Hive.openBox<Message>('messages_${widget.user.id}');
    //checkForUnreadMessages(box);
    oldestMessageId = box.getAt(box.length - 1).id;
    latestMessageId = box.getAt(0).id;
    // setState(() {
    //   messagesList = box.values.toList();
    // });
  }

  bool isKeyboardVisible() {
    return MediaQuery.of(context).viewInsets.bottom != 0.0;
  }

  void checkForUnreadMessages(Box<Message> _messagesBox) async {
    for (var i = 0; i < _messagesBox.length; i++) {
      Message message = _messagesBox.getAt(i);
      if (message.senderId == widget.user.id && (message.sending == null)) {
        if (message.unread) {
          ApiClient.apiClient.markMessageSeen(widget.user.id.toString());
          var key = _messagesBox.keyAt(i);
          message.unread = false;
          await _messagesBox.put(key, message);

          Box<ChatsConversationModel> conversationsBox =
              await Hive.openBox('conversationsBox');
          ChatsConversationModel conversationModel = conversationsBox.values
              .toList()
              .firstWhere((element) => element.id == widget.user.id);
          int index = conversationsBox.values
              .toList()
              .indexWhere((element) => element.id == widget.user.id);
          List<ChatsConversationModel> conversations =
              conversationsBox.values.toList();

          conversationModel.lastMessage = message;
          conversationModel.unreadMessages = 0;
          conversations.removeAt(index);
          conversations.insert(index, conversationModel);
          conversations = sortChats(conversations);
          conversationsBox = await Hive.openBox('conversationsBox');
          await conversationsBox.clear();
          await conversationsBox.addAll(conversations);
          break;
        }
      }
    }
  }

  Map<DateTime, List<Message>> mapMessagesWithDates(List<Message> messages) {
    Map<DateTime, List<Message>> messagesMap = Map();
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');
    for (var message in messages) {
      var dateWithTime = format.parse(message.time);
      DateTime date =
          DateTime.utc(dateWithTime.year, dateWithTime.month, dateWithTime.day);
      messagesMap[date] = [];
    }

    for (var key in messagesMap.keys) {
      List<Message> messagesInDate = [];
      messagesInDate.addAll(messages.where((message) {
        var dateWithTime = format.parse(message.time);
        DateTime date = DateTime.utc(
            dateWithTime.year, dateWithTime.month, dateWithTime.day);
        return date == key;
      }));
      messagesMap[key] = messagesInDate;
    }
    return messagesMap;
  }

  void onNewMessage(Message message) async {
    Box<Message> box =
        await Hive.openBox<Message>('messages_${widget.user.id}');
    checkForUnreadMessages(box);
  }

  checkUserStatus() {
    final FirebaseDatabase firebaseDatabase = FirebaseDatabase();
    var userRef = firebaseDatabase
        .reference()
        .child('status')
        .child(widget.user.id.toString());
    userStatusSubscription = userRef.onValue.listen((event) {
      if (event.snapshot.value != null &&
          event.snapshot.value['state'] == 'online') {
        setState(() {
          isUserOnline = true;
        });
      } else {
        setState(() {
          isUserOnline = false;
        });
      }
    });
  }

  @override
  void dispose() {
    chatService.stopListeningOnChatScreen();
    typingEventsSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    userStatusSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (refreshState) {
        chatService.stopListeningOnChatScreen();
        typingEventsSubscription.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (refreshState) {
        chatService.listeningToMessagesOnChatScreen(
            widget.user.id.toString(), updateChatMessages, onNewMessage);
        chatMessagesBloc.add(GetMessages(userId: widget.user.id.toString()));
        typingEventsStream = chatService.listeningToMessagesOnChatScreen(
            widget.user.id.toString(), updateChatMessages, onNewMessage);
        typingEventsSubscription = typingEventsStream.listen((event) {
          if (event) {
            if (_timer != null && _timer.isActive)
              resetTimer();
            else
              startTimer();

            setState(() {
              userTyping = true;
            });
          } else {
            if (_timer != null && _timer.isActive) {
              _timer.cancel();
              _currentTimer = 0;
              setState(() {
                userTyping = false;
              });
            }
          }
        });
      }
      refreshState = true;
    }
  }

  String getDateString(DateTime date) {
    var todayDate = DateTime.now();
    var yesterdayDate = todayDate.subtract(Duration(days: 1));
    var dateFormat = DateFormat('EEE, dd/MM/y');
    var dateString;
    if (date.day == todayDate.day &&
        date.month == todayDate.month &&
        date.year == todayDate.year) {
      dateString = 'Today';
    } else if (date.day == yesterdayDate.day &&
        date.month == yesterdayDate.month &&
        date.year == yesterdayDate.year) {
      dateString = 'Yesterday';
    } else
      dateString = dateFormat.format(date);

    return dateString;
  }

  showMessageDeleteDialog(bool sender, Message message) async {
    String deleteFor = await showDialog(
        context: context,
        builder: (context) =>
            DeleteMessageDialog(widget.user.displayName, sender));
    if (deleteFor != null) {
      if (deleteFor == 'everyone') {
        chatService.deleteMessage(true, message);
      } else {
        chatService.deleteMessage(false, message);
      }
    }
  }
}

class DeleteMessageDialog extends StatefulWidget {
  final String userName;
  final bool sender;
  DeleteMessageDialog(this.userName, this.sender);
  @override
  _DeleteMessageDialogState createState() => _DeleteMessageDialogState();
}

class _DeleteMessageDialogState extends State<DeleteMessageDialog> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Message?',
              style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 13,
            ),
            (widget.sender)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                          value: checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              this.checkBoxValue = value;
                            });
                          }),
                      Text(
                        'Also delete for ${widget.userName}',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )
                : Offstage(),
            (widget.sender)
                ? SizedBox(
                    height: 13,
                  )
                : Offstage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(0xFF4CD964),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () async {
                        if (checkBoxValue)
                          Navigator.of(context).pop('everyone');
                        else
                          Navigator.of(context).pop('me');
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
