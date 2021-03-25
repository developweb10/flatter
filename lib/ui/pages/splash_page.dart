import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/get_avatars_repository.dart';
import '../../repositories/get_gift_list_repository.dart';
import 'onboarding/onboarding_screen.dart';
import '../../utils/FadeTransition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'login/login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  Function wp;
  String _userId = "";
  AnimationController controller;
  Animation<double> animaton;
  GetAvatarRepository getAvatarRepository = GetAvatarRepository();
  GetGiftListRepository getGiftListRepository = GetGiftListRepository();
  ProgressDialog _loading_info;
  
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    getAvatarRepository.getAvatars();
    // getGiftListRepository.getGifts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkUser(context);
    wp = Screen(MediaQuery.of(context).size).wp;
    _loading_info =
        new ProgressDialog(context, type: ProgressDialogType.Normal);
    _loading_info.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: const Color(0xff212121),
      progressWidget: Container(
          padding: EdgeInsets.all(15.0),
          height: 40,
          width: 40,
          child: CircularProgressIndicator()),
      insetAnimCurve: Curves.bounceIn,
      messageTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 16.0,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Center(
            child: ScaleTransition(
              scale: animaton,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.4, 0.7, 0.9],
                    colors: [
                      Color(0xFFff6060),
                      Color(0xFFff6060),
                      Color(0xFFfe4a49),
                      Color(0xFFfe4a49),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: wp(16),
                child: SvgPicture.asset(
                  'assets/svg/krushin_logo.svg',
                  color: Theme.of(context).primaryColor,
                  width: (wp(16) * 2) - 32,
                )),
          )
        ],
      ),
    );
  }

  checkUser(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double diagonal =
        sqrt((screenHeight * screenHeight) + (screenWidth * screenWidth));
    double scale = (diagonal / MediaQuery.of(context).size.width);
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animaton = Tween<double>(begin: 0, end: scale)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    Timer(Duration(milliseconds: 500), () async {
      controller.forward();
      await Future.delayed(Duration(milliseconds: 1500));

      bool signinstatus = await UserSettingsManager.getSigninStatus();

      if (signinstatus) {
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/MainScreen');
      } else {
        if (await UserSettingsManager.getshowOnBoardingScreens()) {
          UserSettingsManager.setshowOnBoardingScreens(false);
          Navigator.pushReplacement(
              context, FadeRouteBuilder(page: OnboardingScreen()));
        } else {
          Navigator.pushReplacement(
              context, FadeRouteBuilder(page: LoginPage()));
          //             Navigator.pushReplacement(
          // context, FadeRouteBuilder(page: SubscriptionScreen()));
        }
      }
      //             Navigator.pushReplacement(
      // context, FadeRouteBuilder(page: InApp1()));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
