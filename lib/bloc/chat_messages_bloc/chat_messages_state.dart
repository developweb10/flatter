part of 'chat_messages_bloc.dart';

@immutable
abstract class ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final List<Message> messages;
  ChatMessagesLoaded(this.messages);
}

class OlderMessagesLoaded extends ChatMessagesState {
  final List<Message> messages;
  OlderMessagesLoaded(this.messages);
}

class ChatMessagesError extends ChatMessagesState {
  final String message;
  ChatMessagesError({this.message});
}
