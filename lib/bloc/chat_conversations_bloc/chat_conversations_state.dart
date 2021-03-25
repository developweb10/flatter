part of 'chat_conversations_bloc.dart';

@immutable
abstract class ChatConversationsState {}

class ChatConversationsLoading extends ChatConversationsState {}

class ChatConversationsLoaded extends ChatConversationsState {
  final List<ChatsConversationModel> userConversations;
  final List<BlockedConversationModel> blockedConversations;
  ChatConversationsLoaded(this.userConversations, this.blockedConversations);
}

class ChatConversationsError extends ChatConversationsState {}
