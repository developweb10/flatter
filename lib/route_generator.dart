import 'package:flutter/material.dart';
import 'package:krushapp/ui/pages/accept_krush_screen.dart';
import 'ui/pages/gifts/confirm_gift_page.dart';
import 'ui/pages/gifts/gift_listing_page.dart';
import 'ui/pages/home/main_page.dart';
import 'ui/pages/reveal_info/krush_chat_page.dart';

import 'ui/pages/account_page.dart';
import 'ui/pages/add_krush_page.dart';
import 'ui/pages/chat_settings_page.dart';
import 'ui/pages/contacts_page.dart';
import 'ui/pages/edit_account_details.dart';
import 'ui/pages/krush_reveal_page.dart';
import 'ui/pages/login/login_page.dart';
import 'ui/pages/reveal_info/kursh_phone_page.dart';
import 'ui/pages/reveal_info/reveal_info_page.dart';
import 'ui/pages/splash_page.dart';
import 'ui/pages/login/verification_page.dart';
import 'ui/pages/subscription_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/SplashPage':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/LoginPage':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/VerificationPage':
        return MaterialPageRoute(builder: (_) => VerificationPage(args));
      case '/KrushChatPage':
        return MaterialPageRoute(builder: (_) => KrushChatPage(args));
      case '/KrushPhonePage':
        return MaterialPageRoute(builder: (_) => KrushPhonePage(args));
      case '/RevealInformationPage':
        return MaterialPageRoute(builder: (_) => RevealInformationPage(args));
      case '/MainScreen':
        return MaterialPageRoute(builder: (_) => MainScreen(imageFile: args,));
      // case '/HomePage':
      //   return MaterialPageRoute(builder: (_) => HomePage());
      // case '/KrushesPage':
      //   return MaterialPageRoute(builder: (_) => KrushesPage(args));
      // case '/GiftStorePage':
      //   return MaterialPageRoute(builder: (_) => GiftStorePage());
      // case '/ProfilePage':
      //   return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/AccountPage':
        return MaterialPageRoute(builder: (_) => AccountPage(args));
      case '/AddKrushPage':
        return MaterialPageRoute(builder: (_) => AddKrushPage());
      // case '/ChatImageScreen':
      //   return MaterialPageRoute(builder: (_) => ChatImageScreen());
      // case '/ChatScreen':
      //   return MaterialPageRoute(builder: (_) => ChatScreen());
      case '/ChatOptionsScreen':
        return MaterialPageRoute(builder: (_) => ChatOptionsScreen(args));
      case '/ContactsPage':
        return MaterialPageRoute(builder: (_) => ContactsPage());
      case '/EditAccountDetails':
        return MaterialPageRoute(builder: (_) => EditAccountDetails(args));
      case '/KrushRevealPage':
        return MaterialPageRoute(builder: (_) => KrushRevealPage(args));
      // case '/KrushinCoinsPage':
      //   return MaterialPageRoute(builder: (_) => KrushinCoinsPage(args));
      // case '/PaymentPage':
      //   return MaterialPageRoute(builder: (_) => PaymentPage(args));
              case '/SubscriptionScreen':
        return MaterialPageRoute(builder: (_) => SubscriptionScreen(args));
       
      case '/AcceptKrushScreen':
        return MaterialPageRoute(builder: (_) => AcceptKrushScreen(args));

      case '/ConfirmGiftPage':
        return MaterialPageRoute(builder: (_) => ConfirmGiftPage());
      default:
        // If there is no such named route in the switch statement'], e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SizedBox(height: 0)));
    }
  }
}
