import 'dart:async';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_audio_player/flutter_audio_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as Image;
import 'package:intl/intl.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/chat_conversation_model.dart';
import 'package:krushapp/model/message_model.dart' as chat;
import 'package:krushapp/repositories/ads_repository.dart';
import 'package:krushapp/utils/utils.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ChatService {
  ApiClient _client;
  Box<chat.Message> _messagesBox;
  Box<ChatsConversationModel> _conversationsBox;
  FlutterPusher _pusher;
  Echo _echo;
  String token, currentUserID;
  String otherUserId;
  Function onChatUpdate;
  Function(chat.Message message) onNewMessage;

  int adCounter = 0;

  var chatChannel;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  final StreamController<bool> _typingEventsController =
      StreamController<bool>.broadcast();
  AdmobInterstitial interstitialAd;
  ChatService() {
    _client = ApiClient.apiClient;
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        // requestSoundPermission: false,
        // requestBadgePermission: false,
        // requestAlertPermission: false,
        );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void receiveMessages() {
    try {
      _connectSocket();
    } catch (e) {
      throw e;
    }
  }

  void disconnect() {
    try {
      if (_echo != null) _echo.disconnect();
    } catch (e) {
      throw e;
    }
  }

  Stream<bool> listeningToMessagesOnChatScreen(String otherUserId,
      Function() onChatUpdate, Function(chat.Message message) onNewMessage) {
    this.otherUserId = otherUserId;
    this.onChatUpdate = onChatUpdate;
    this.onNewMessage = onNewMessage;
    return _typingEventsController.stream.asBroadcastStream();
  }

  void stopListeningOnChatScreen() {
    this.otherUserId = null;
    this.onChatUpdate = null;
    this.onNewMessage = null;
  }

  void whisperTyping(String userId) async {
    try {
      ApiClient.apiClient.typingMessage(userId);
    } catch (e) {
      throw e;
    }
  }

  void _connectSocket() async {
    try {
      if (token == null) token = await UserSettingsManager.getUserToken();

      var options = PusherOptions(
          auth: PusherAuth('https://krushin.site/broadcasting/auth',
              headers: {'Authorization': 'Bearer $token'}),
          cluster: 'mt1',
          host: 'krushin.site',
          port: 6001,
          encrypted: true);
      _pusher = FlutterPusher(
        'anyKey',
        options,
        onError: (error) {
        },
      );

      _echo = Echo({
        'broadcaster': 'pusher',
        'client': _pusher,
        'auth': {
          'headers': {'Authorization': 'Bearer $token'}
        }
      });

      _pusher.connect(onConnectionStateChange: (event) {
        if (event.currentState == 'CONNECTED' ||
            event.currentState == 'connected') {

          _listenForMessages();
        } else if (event.currentState == 'DISCONNECTED' ||
            event.currentState == 'disconnected') {
        } else {
        }
      }, onError: (error) {
      });
    } catch (e) {
      throw e;
    }
  }

  void _listenForMessages() async {
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

    if (currentUserID == null)
      currentUserID = await UserSettingsManager.getUserID();

    var chatChannel = _echo.private('privatechat.$currentUserID');

    chatChannel.listen('SendPrivateMessage', (e) async {
      incrementCounter();
      chat.Message receivedMessage = chat.Message.fromJson(e['message']);
      if (this.otherUserId == null ||
          (this.otherUserId != receivedMessage.senderId.toString())) {
        FlutterRingtonePlayer.playNotification();
      } else {
        audioPlayer.open(
          Audio('assets/sounds/message_receiving.wav'),
          showNotification: false,
          volume: 0.5,
          respectSilentMode: true,
        );
        // AudioPlayer.addSound('assets/sounds/message_receiving.wav');
        // Future.delayed(Duration(milliseconds: 1000), () {
        //   AudioPlayer.removeAllSound();
        // });
        _typingEventsController.sink.add(false);
      }
      await _addMessageToCache(
          receivedMessage, receivedMessage.senderId.toString());
      if (this.onNewMessage != null) onNewMessage(receivedMessage);
    });

    chatChannel.listen('MessageTyping', (e) {
      if (this.otherUserId != null &&
          this.otherUserId == e['user']['id'].toString()) {
        _typingEventsController.sink.add(true);
      }
    });

    chatChannel.listen('MessageStatus', (e) {
      _setMessageSeenStatus(e['id'].toString(), e['toUser']['id'].toString());
    });

    chatChannel.listen('MessageDelete', (e) {
      deleteUserMessage(e['id'].toString());
    });

    chatChannel.listen('MessageLike', (e) {
      incrementCounter();
      _setMessageLikedStatus(e['toUser']['id'].toString(), e['id'].toString());
    });

    _echo.join('plchat.$currentUserID').here((users) {
    }).joining((user) {
    }).leaving((user) {
    });
  }

  Future likeMessage(String toUserId, String messageId) async {
    try {
      if (token == null) token = await UserSettingsManager.getUserToken();
      _messagesBox = await Hive.openBox('messages_$toUserId');
      final response = await _client.markMessageLiked( messageId);
      incrementCounter();
      List<chat.Message> messages = _messagesBox.values.toList();
      int messageIndex =
          messages.indexWhere((element) => element.id.toString() == messageId);
      messages[messageIndex].isLiked = !messages[messageIndex].isLiked;
      var key = _messagesBox.keyAt(messageIndex);
      await _messagesBox.put(key, messages[messageIndex]);
      if (onChatUpdate != null) onChatUpdate();
    } catch (e) {
      toast('Some Error Occurred! Please try again');
      throw e;
    }
  }

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

  Future<void> sendMessage(String message, String toUserId, String relationId,
      {File imageFile, String gifUrl}) async {
    try {
      audioPlayer.open(
        Audio('assets/sounds/message_sending.wav'),
        showNotification: false,
        volume: 0.5,
        respectSilentMode: true,
      );
      // AudioPlayer.addSound('assets/sounds/message_sending.wav');
      // Future.delayed(Duration(milliseconds: 1000), () {
      //   AudioPlayer.removeAllSound();
      // });
      if (token == null) token = await UserSettingsManager.getUserToken();
      if (currentUserID == null)
        currentUserID = await UserSettingsManager.getUserID();

      _messagesBox = await Hive.openBox('messages_$toUserId');
      _conversationsBox = await Hive.openBox('conversationsBox');
      var messageResponse;
      if (imageFile != null) {
        Image.Image image = Image.decodeImage(imageFile.readAsBytesSync());
        Image.Image resizedImage;
        if (image.width > image.height) {
          resizedImage = Image.copyResize(image, height: 480);
        } else {
          resizedImage = Image.copyResize(image, width: 480);
        }
        var cacheDir = await getTemporaryDirectory();

        String filePath = path.join(cacheDir.path,
            '${path.basenameWithoutExtension(imageFile.path)}.jpg');
        File resizedImageFile =
            await File(filePath).writeAsBytes(Image.encodeJpg(resizedImage));

        if (resizedImageFile.existsSync()) {
          var format = DateFormat('yyyy-MM-dd HH:mm:ss');
          chat.Message sendingImageMessage = chat.Message(
              id: DateTime.now().millisecondsSinceEpoch,
              senderId: int.parse(currentUserID),
              time: format.format(DateTime.now()),
              sending: true,
              image: resizedImageFile.path);
          var messageKey =
              await _addMessageToCache(sendingImageMessage, toUserId);
          if (this.onNewMessage != null) onNewMessage(sendingImageMessage);

          messageResponse = await _client.sendImageMessage(
               toUserId, resizedImageFile, message, relationId);
          incrementCounter();
          chat.Message sentMessage =
              chat.Message.fromJson(messageResponse['message']);
          chat.Message previousMessage = _messagesBox.get(messageKey);
          previousMessage = sentMessage;
          await _messagesBox.put(messageKey, previousMessage);
          if (this.onChatUpdate != null) onChatUpdate();
        }
      } else if (gifUrl != null) {
        var format = DateFormat('yyyy-MM-dd HH:mm:ss');
        chat.Message sendingMessage = chat.Message(
            id: DateTime.now().millisecondsSinceEpoch,
            senderId: int.parse(currentUserID),
            time: format.format(DateTime.now()),
            sending: true,
            text: message);
        var messageKey = await _addMessageToCache(sendingMessage, toUserId);
        if (this.onNewMessage != null) onNewMessage(sendingMessage);

        try {
          messageResponse = await _client.sendMessage(
           toUserId, message, relationId,
              gifUrl: gifUrl);
          incrementCounter();
          chat.Message sentMessage =
              chat.Message.fromJson(messageResponse['message']);
          chat.Message previousMessage = _messagesBox.get(messageKey);
          previousMessage = sentMessage;
          await _messagesBox.put(messageKey, previousMessage);
          if (this.onChatUpdate != null) onChatUpdate();
        } catch (e) {
          await _messagesBox.delete(messageKey);
          if (this.onChatUpdate != null) onChatUpdate();
        }
      } else {
        var format = DateFormat('yyyy-MM-dd HH:mm:ss');
        chat.Message sendingMessage = chat.Message(
            id: DateTime.now().millisecondsSinceEpoch,
            senderId: int.parse(currentUserID),
            time: format.format(DateTime.now()),
            sending: true,
            text: message);
        var messageKey = await _addMessageToCache(sendingMessage, toUserId);
        if (this.onNewMessage != null) onNewMessage(sendingMessage);

        try {
          messageResponse =
              await _client.sendMessage(toUserId, message, relationId);
          incrementCounter();
          chat.Message sentMessage =
              chat.Message.fromJson(messageResponse['message']);
          chat.Message previousMessage = _messagesBox.get(messageKey);
          previousMessage = sentMessage;
          await _messagesBox.put(messageKey, previousMessage);
          //await Future.delayed(Duration(milliseconds: 500));
          if (this.onChatUpdate != null) onChatUpdate();
        } catch (e) {
          await _messagesBox.delete(messageKey);
          if (this.onChatUpdate != null) onChatUpdate();
        }
      }
    } catch (e) {
      toast('Error sending message');
      throw e;
    }
  }

  Future deleteUserMessage(String messageId) async {
    try {
      if (_messagesBox == null)
        _messagesBox = await Hive.openBox('messages_$otherUserId');

      if (_conversationsBox == null)
        _conversationsBox = await Hive.openBox('conversationsBox');

      ChatsConversationModel conversationModel = _conversationsBox.values
          .toList()
          .firstWhere((element) => element.id.toString() == otherUserId);
      int index = _conversationsBox.values
          .toList()
          .indexWhere((element) => element.id.toString() == otherUserId);

      //deleting message

      List<chat.Message> cachedMessages = List();
      cachedMessages = _messagesBox.values.toList();
      cachedMessages
          .removeWhere((message) => message.id.toString() == messageId);
      await _messagesBox.clear();
      await _messagesBox.addAll(cachedMessages);

      List<ChatsConversationModel> conversations =
          _conversationsBox.values.toList();

      conversationModel.lastMessage = cachedMessages[0];
      conversations.removeAt(index);
      conversations.insert(index, conversationModel);
      //sorting conversations on basis of date
      conversations = sortChats(conversations);
      _conversationsBox = await Hive.openBox('conversationsBox');
      await _conversationsBox.clear();
      await _conversationsBox.addAll(conversations);
      if (this.onChatUpdate != null) onChatUpdate();
    } catch (e) {
      toast('Error deleting message');
      throw e;
    }
  }

  Future deleteMessage(bool deleteForAll, chat.Message message) async {
    try {
      if (_messagesBox == null)
        _messagesBox = await Hive.openBox('messages_$otherUserId');

      if (_conversationsBox == null)
        _conversationsBox = await Hive.openBox('conversationsBox');

      if (token == null) token = await UserSettingsManager.getUserToken();

      ChatsConversationModel conversationModel = _conversationsBox.values
          .toList()
          .firstWhere((element) => element.id.toString() == otherUserId);
      int index = _conversationsBox.values
          .toList()
          .indexWhere((element) => element.id.toString() == otherUserId);

      //deleting message
      if (deleteForAll) {
        await _client.deleteMessageForAll( message.id.toString());
      } else {
        await _client.deleteMessageForMe( message.id.toString());
      }
      List<chat.Message> cachedMessages = List();
      cachedMessages = _messagesBox.values.toList();
      cachedMessages.remove(message);
      await _messagesBox.clear();
      await _messagesBox.addAll(cachedMessages);

      List<ChatsConversationModel> conversations =
          _conversationsBox.values.toList();

      conversationModel.lastMessage = cachedMessages[0];
      conversations.removeAt(index);
      conversations.insert(index, conversationModel);
      //sorting conversations on basis of date
      conversations = sortChats(conversations);
      _conversationsBox = await Hive.openBox('conversationsBox');
      await _conversationsBox.clear();
      await _conversationsBox.addAll(conversations);
      if (this.onChatUpdate != null) onChatUpdate();
    } catch (e) {
      toast('Error deleting message');
      throw e;
    }
  }

  Future _addMessageToCache(chat.Message message, String otherUserId) async {
    if (_messagesBox == null)
      _messagesBox = await Hive.openBox('messages_$otherUserId');

    if (_conversationsBox == null)
      _conversationsBox = await Hive.openBox('conversationsBox');

    ChatsConversationModel conversationModel = _conversationsBox.values
        .toList()
        .firstWhere((element) => element.id.toString() == otherUserId);
    int index = _conversationsBox.values
        .toList()
        .indexWhere((element) => element.id.toString() == otherUserId);

    List<chat.Message> cachedMessages = List();
    cachedMessages = _messagesBox.values.toList();
    cachedMessages.insert(0, message);
    await _messagesBox.clear();
    await _messagesBox.addAll(cachedMessages);

    List<ChatsConversationModel> conversations =
        _conversationsBox.values.toList();

    conversationModel.lastMessage = message;
    conversationModel.unreadMessages = conversationModel.unreadMessages + 1;
    conversationModel.updatedAt = message.time;
    conversations.removeAt(index);
    conversations.insert(index, conversationModel);
    //sorting conversations on basis of date
    conversations = sortChats(conversations);
    _conversationsBox = await Hive.openBox('conversationsBox');
    await _conversationsBox.clear();
    await _conversationsBox.addAll(conversations);
    return _messagesBox.keyAt(0);
  }

  void _setMessageSeenStatus(String messageId, String otherUserId) async {
    if (_messagesBox == null)
      _messagesBox = await Hive.openBox('messages_$otherUserId');

    if (_messagesBox.getAt(0).senderId.toString() != otherUserId) {
      var key = _messagesBox.keyAt(0);

      chat.Message message = _messagesBox.getAt(0);
      message.unread = false;
      await _messagesBox.put(key, message);
      if (onChatUpdate != null) onChatUpdate();
    }
  }

  Future _setMessageLikedStatus(String userId, String messageId) async {
    try {
      if (_messagesBox == null)
        _messagesBox = await Hive.openBox('messages_$userId');

      List<chat.Message> messages = _messagesBox.values.toList();
      int messageIndex =
          messages.indexWhere((element) => element.id.toString() == messageId);
      messages[messageIndex].isLiked = !messages[messageIndex].isLiked;

      int key = _messagesBox.keyAt(messageIndex);
      await _messagesBox.put(key, messages[messageIndex]);
      if (onChatUpdate != null) onChatUpdate();
    } catch (e) {
    }
  }

  Future<void> _showLikedMessageNotification(
      int messageId, String userName) async {
    try {
      String channelId = 'chat';
      String channelName = 'Chat Messages';
      String channelDescription = 'Alerts for new messages';
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        category: 'message liked',
      );
      IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
      var platformSpecifics = NotificationDetails(
          androidNotificationDetails, iosNotificationDetails);

      await _flutterLocalNotificationsPlugin.show(
        messageId,
        'Krushin',
        '$userName liked a message you sent',
        platformSpecifics,
      );
    } catch (e) {
    }
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdsRepository.getInterstitialAdUnitId(),
      listener: (MobileAdEvent event) {
      },
    );
  }

  incrementCounter() async {
    if (await UserSettingsManager.getSubsciptionStatus() != 1) {
      adCounter = adCounter + 1;
      if (adCounter > 50) {
        createInterstitialAd()
          ..load()
          ..show().then((value) {
            adCounter = 0;
          });
      }
    }
  }

  Future<void> _showMessageNotification(
      String otherUserId, chat.Message message) async {
    String channelId = 'chat';
    String channelName = 'Chat Messages';
    String channelDescription = 'Alerts for new messages';
    Person person = Person(
        name: '${message.senderId}',
        key: message.senderId.toString(),
        icon: FlutterBitmapAssetAndroidIcon('assets/images/avatar1.png'));

    List<Message> unreadMessages = [
      Message(message.text, DateTime.now(), person)
    ];

    var messagingStyle = MessagingStyleInformation(person,
        groupConversation: false,
        conversationTitle: '${message.senderId} Title',
        messages: unreadMessages);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      category: 'msg',
      styleInformation: messagingStyle,
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    var platformSpecifics =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.senderId,
      '${message.id}',
      message.text,
      platformSpecifics,
    );
  }
}
