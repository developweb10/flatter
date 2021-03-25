import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/ui/widgets/news_feeds.dart';
import 'bloc/account_page_bloc/account_page_bloc.dart';
import 'bloc/ads_bloc/ads_bloc.dart';
import 'bloc/bottom_nav_counters_bloc/bottom_nav_counters_bloc.dart';
import 'bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import 'bloc/krush_active_bloc/krush_active_bloc.dart';
import 'bloc/krush_recieved_bloc/krush_recieved_bloc_bloc.dart';
import 'bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart';
import 'bloc/request_action_bloc/request_action_bloc.dart';
import 'bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'bloc/gift_recieved_bloc/gift_recieved_bloc_bloc.dart';
import 'bloc/krush_add_bloc/krush_add_bloc.dart';
import 'route_generator.dart';
import 'utils/hive_init.dart';
import 'utils/service_locator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'app/theme.dart';
import 'bloc/chat_conversations_bloc/chat_conversations_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Admob.requestTrackingAuthorization();
  await setUpHive();
  setupServiceLocator();
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<BottomNavCountersBloc>(
              create: (context) => BottomNavCountersBloc(),
            ),
            BlocProvider<GiftSentBloc>(create: (context) => GiftSentBloc()),
            BlocProvider<GiftRecievedBloc>(
                create: (context) => GiftRecievedBloc()),
            BlocProvider<KrushSentBloc>(create: (context) => KrushSentBloc()),
            BlocProvider<KrushRequestBloc>(
                create: (context) => KrushRequestBloc()),
            BlocProvider<SubscriptionBlocBloc>(
                create: (context) => SubscriptionBlocBloc()),
            BlocProvider<KrushActiveBloc>(
                create: (context) => KrushActiveBloc()),
            BlocProvider<AccountPageBloc>(
                create: (context) => AccountPageBloc()),
            BlocProvider<ChatConversationsBloc>(
                create: (context) => ChatConversationsBloc()),
            BlocProvider<KrushAddBloc>(create: (context) => KrushAddBloc()),
            BlocProvider<KrushActiveBloc>(
                create: (context) => KrushActiveBloc()),
            BlocProvider<RequestActionBloc>(
                create: (context) => RequestActionBloc()),
            BlocProvider<SubscriptionBlocBloc>(
                create: (context) => SubscriptionBlocBloc()),
            BlocProvider<AdsBloc>(create: (context) => AdsBloc()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: finalTheme,
            // home: SplashPage(),
            initialRoute: '/MainScreen',
            onGenerateRoute: RouteGenerator.generateRoute,
          )),
    );
  }
}
