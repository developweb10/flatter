import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/model/blocked_conversation_model.dart';
import '../../app/shared_prefrence.dart';
import '../../model/chat_conversation_model.dart';
import '../../repositories/chat_conversations_repository.dart';
import '../../utils/service_locator.dart';
import 'package:meta/meta.dart';

part 'chat_conversations_event.dart';
part 'chat_conversations_state.dart';

class ChatConversationsBloc
    extends Bloc<ChatConversationsEvent, ChatConversationsState> {
  ChatConversationsBloc() : super(ChatConversationsLoading());
  final ChatConversationsRepository conversationsRepository =
      locator<ChatConversationsRepository>();

  @override
  Stream<ChatConversationsState> mapEventToState(
    ChatConversationsEvent event,
  ) async* {
    yield ChatConversationsLoading();

    if (event is GetUserConversations) {
      try {
        String userToken = await UserSettingsManager.getUserToken();
        var userConversations =
            await conversationsRepository.getUserConversations(userToken);
                
        var blockedConversations =
            await conversationsRepository.getBlockedConversations(userToken);
        yield ChatConversationsLoaded(userConversations, blockedConversations);
      } catch (e) {
        
        yield ChatConversationsError();
      }
    }
  }
}
