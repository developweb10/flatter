import 'package:get_it/get_it.dart';
import 'package:krushapp/network/api_client.dart';
import 'package:krushapp/repositories/chat_conversations_repository.dart';
import 'package:krushapp/repositories/chat_messages_repository.dart';
import 'package:krushapp/services/chat_service.dart';

GetIt locator = GetIt.instance;

setupServiceLocator() {
  locator.registerLazySingleton(() => ChatConversationsRepository());
  locator.registerLazySingleton(() => ChatMessagesRepository());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => ApiClient());
}
