import 'package:hive/hive.dart';
import 'package:krushapp/model/blocked_conversation_model.dart';
import 'package:krushapp/model/chat_conversation_model.dart';
import 'package:krushapp/model/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChatsConversationModelAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(BlockedConversationModelAdapter());
}
