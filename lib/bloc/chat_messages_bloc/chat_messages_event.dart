part of 'chat_messages_bloc.dart';

@immutable
abstract class ChatMessagesEvent {}

class GetMessages extends ChatMessagesEvent {
  final String userId;
  GetMessages({
    this.userId,
  });
}

class GetOlderMessages extends ChatMessagesEvent {
  final String userId;
  final String oldMessageId;
  GetOlderMessages({this.userId, this.oldMessageId});
}
