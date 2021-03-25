import 'package:hive/hive.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/message_model.dart';

class ChatMessagesRepository {
  ApiClient _client;
  Box<Message> _messagesBox;

  ChatMessagesRepository() : _client = ApiClient.apiClient;

  Future<List<Message>> getMessages(
    String userId,
  ) async {
    try {
      _messagesBox = await Hive.openBox('messages_$userId');
      if (_messagesBox.isEmpty)
        return await getInitialMessagesFromApi(userId);
      else {
        getInitialMessagesFromApi(userId);
        return await getCachedMessages(userId);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Message>> getOlderMessages(
      String token, String oldMessageId, String userId) async {
    List<Message> messages = List();
    try {
      final response = await _client.getPreviousMessages(oldMessageId);
      messages =
          response.map<Message>((json) => Message.fromJson(json)).toList();
      await _cacheMessages(userId, messages);
      return messages;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Message>> getCachedMessages(String userId) async {
    List<Message> messages = List();
    try {
      _messagesBox = await Hive.openBox('messages_$userId');

      messages.addAll(_messagesBox.values);

      return messages;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Message>> getInitialMessagesFromApi(
      String userId) async {
    List<Message> messages = List();
    try {
      final response = await _client.getInitialMessages(userId);
      response.forEach((element) {
      });
      messages =
          response.map<Message>((json) => Message.fromJson(json)).toList();
      _messagesBox = await Hive.openBox('messages_$userId');
      await _messagesBox.clear();
      await _cacheMessages(userId, messages);
      return messages;
    } catch (e) {
      throw e;
    }
  }

  // Future<void> _getLatestMessagesFromApi(
  //     String userId, String latestMessageId, String token) async {
  //   List<Message> messages = List();
  //   try {
  //     final List response =
  //         await _client.getLatestMessages(latestMessageId, token);
  //     if (response.isNotEmpty) {
  //       messages =
  //           response.map<Message>((json) => Message.fromJson(json)).toList();
  //       _cacheNewerMessages(userId, messages);
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> _cacheMessages(String userId, List<Message> messages) async {
    try {
      _messagesBox = await Hive.openBox('messages_$userId');

      for (var i = 0; i < messages.length; i++) {
        await _messagesBox.add(messages[i]);
      }
    } catch (e) {
      throw e;
    }
  }

  // Future<void> _cacheNewerMessages(
  //     String userId, List<Message> messages) async {
  //   try {
  //     _messagesBox = await Hive.openBox('messages_$userId');

  //     List<Message> newMessages = messages;
  //     List<Message> cachedMessages = List();
  //     for (var i = 0; i < _messagesBox.length; i++) {
  //       cachedMessages.add(_messagesBox.getAt(i));
  //     }
  //     newMessages.addAll(cachedMessages);
  //     await _messagesBox.clear();
  //     for (var i = 0; i < messages.length; i++) {
  //       await _messagesBox.add(newMessages[i]);
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
