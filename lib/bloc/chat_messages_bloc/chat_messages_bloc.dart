import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import '../../app/shared_prefrence.dart';
import '../../model/message_model.dart';
import '../../repositories/chat_messages_repository.dart';
import '../../utils/service_locator.dart';
import 'package:meta/meta.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final ChatMessagesRepository chatMessagesRepository =
      locator<ChatMessagesRepository>();

  ChatMessagesBloc() : super(ChatMessagesLoading());

  @override
  Stream<ChatMessagesState> mapEventToState(
    ChatMessagesEvent event,
  ) async* {
    if (event is GetMessages) {
      yield ChatMessagesLoading();
      try {
        Box<Message> _messagesBox =
            await Hive.openBox('messages_${event.userId}');
        if (_messagesBox.isEmpty) {
          List<Message> messages =
              await chatMessagesRepository.getInitialMessagesFromApi(
                  event.userId);
          yield ChatMessagesLoaded(messages);
        } else {
          List<Message> messages =
              await chatMessagesRepository.getCachedMessages(event.userId);
          yield ChatMessagesLoaded(messages);
          List<Message> networkMessages =
              await chatMessagesRepository.getInitialMessagesFromApi(
                  event.userId);

          yield ChatMessagesLoaded(networkMessages);
        }
      } catch (e) {
        print(e);
        yield ChatMessagesError(message: 'Chat Messages Error');
      }
    } else if (event is GetOlderMessages) {
      try {
        List<Message> messages = await chatMessagesRepository.getOlderMessages(
            await UserSettingsManager.getUserToken(),
            event.oldMessageId,
            event.userId);
        yield OlderMessagesLoaded(messages);
      } catch (e) {
        print(e);
        yield ChatMessagesError(message: e.message);
      }
    }
  }
}
