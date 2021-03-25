import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/blocked_conversation_model.dart';
import 'package:krushapp/model/chat_conversation_model.dart';

class ChatConversationsRepository {
  ApiClient _client;
  Box<ChatsConversationModel> _conversationsBox;
  Box<BlockedConversationModel> _blockedConversationsBox;

  ChatConversationsRepository() : _client = ApiClient.apiClient;

  Future<List<ChatsConversationModel>> getUserConversations(
      String token) async {
    try {
      _conversationsBox =
          await Hive.openBox<ChatsConversationModel>('conversationsBox');
      if (_conversationsBox.isEmpty)
        return _getConversationsFromApi(token);
      else {
        _getConversationsFromApi(token);
        return _getCachedConversations();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<ChatsConversationModel>> _getCachedConversations() async {
    List<ChatsConversationModel> userConversations = List();
    try {
      _conversationsBox =
          await Hive.openBox<ChatsConversationModel>('conversationsBox');
      userConversations = _conversationsBox.values.toList();
      return userConversations;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<ChatsConversationModel>> _getConversationsFromApi(
      String token) async {
    List<ChatsConversationModel> userConversations = List();
    try {
      final response = await _client.getUserConversations();
      print('response');
      userConversations = response
          .map<ChatsConversationModel>(
              (json) => ChatsConversationModel.fromJson(json))
          .toList();
      await _cacheUserConversations(userConversations);
      return userConversations;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> _cacheUserConversations(
      List<ChatsConversationModel> chats) async {
    try {
      var format = DateFormat('yyyy-MM-dd HH:mm:ss');
      chats.sort((a, b) {
        var aDate = format.parse(a.lastMessage.time);
        var bDate = format.parse(b.lastMessage.time);
        return bDate.compareTo(aDate);
      });
      _conversationsBox =
          await Hive.openBox<ChatsConversationModel>('conversationsBox');
      await _conversationsBox.clear();
      await _conversationsBox.addAll(chats);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<BlockedConversationModel>> getBlockedConversations(
      String token) async {
    try {
      _blockedConversationsBox = await Hive.openBox<BlockedConversationModel>(
          'blockedConversationsBox');
      if (_blockedConversationsBox.isEmpty) {
        _getBlockedConversationsFromApi(token);
        return List<BlockedConversationModel>();
      } else {
        _getBlockedConversationsFromApi(token);
        return _getCachedBlockedConversations();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<BlockedConversationModel>>
      _getCachedBlockedConversations() async {
    List<BlockedConversationModel> blockedConversations = List();
    try {
      _blockedConversationsBox = await Hive.openBox<BlockedConversationModel>(
          'blockedConversationsBox');
      blockedConversations = _blockedConversationsBox.values.toList();
      return blockedConversations;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<BlockedConversationModel>> _getBlockedConversationsFromApi(
      String token) async {
    List<BlockedConversationModel> blockedConversations = List();
    try {
      final response = await _client.getBlockedKrushes();
      blockedConversations = response
          .map<BlockedConversationModel>(
              (json) => BlockedConversationModel.fromJson(json))
          .toList();
      await _cacheBlockedConversations(blockedConversations);
      return blockedConversations;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> _cacheBlockedConversations(
      List<BlockedConversationModel> chats) async {
    try {
      var format = DateFormat('yyyy-MM-dd HH:mm:ss');
      chats.sort((a, b) {
        var aDate = format.parse(a.updatedAt);
        var bDate = format.parse(b.updatedAt);
        return bDate.compareTo(aDate);
      });
      _blockedConversationsBox = await Hive.openBox<BlockedConversationModel>(
          'blockedConversationsBox');
      await _blockedConversationsBox.clear();
      await _blockedConversationsBox.addAll(chats);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
