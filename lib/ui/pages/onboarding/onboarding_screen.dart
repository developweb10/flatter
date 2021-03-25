import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/ui/pages/login/login_page.dart';
import 'package:krushapp/ui/widgets/circleProgressBar.dart';
import 'package:krushapp/utils/FadeTransition.dart';

import 'first.dart';
import 'second.dart';
import 'third.dart';

class OnboardingScreen extends StatefulWidget {
  String token;

  OnboardingScreen({Key key, this.token}) : super(key: key);
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  bool animationZeroCompleted = false;
  bool animationOneCompleted = false;
  double screenWidth;
  double screenHeight;
  double progress;
  double _opacity = 1.0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Function wp;
  @override
  void initState() {
    // TODO: implement initState
    progress = 0.25;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Container(
        // decoration: backgroundDecoration,
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
           // FirstImage()
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500),
              child: !animationZeroCompleted
                  ? FirstImage()
                  : !animationOneCompleted ? SecondImage() : ThirdImage(),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // color: Colors.transparent,
                height: screenHeight * 0.37,
                margin: EdgeInsets.only(
                    top: screenHeight * 0.65, bottom: screenHeight * 0.05),

                child: Column(
                  // shrinkWrap: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Spacer(),

                    Row(
                      children: [
                        // Container(),

                        Container(

                            //  height: 100,
                            width: screenWidth,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 700),
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              alignment: currentPage == 0
                                  ? Alignment.centerRight
                                  : currentPage == 1
                                      ? Alignment.centerLeft
                                      : Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: currentPage == 0
                                    ? CrossAxisAlignment.end
                                    : currentPage == 1
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                children: [
                                  AnimatedOpacity(
                                    opacity: _opacity,
                                    duration: Duration(milliseconds: 500),
                                    child: !animationZeroCompleted
                                        ? FirstText()
                                        : !animationOneCompleted
                                            ? SecondText()
                                            : ThirdText(),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Center(
                      child: Container(
                        // padding: EdgeInsets.only(bottom: 10),
                        width: screenHeight * 0.12,
                        alignment: Alignment.bottomCenter,
                        child: CircleProgressBar(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          value: progress,
                          onPageChanged: animateToPage,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  animateToPage() {
    setState(() {
      _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      currentPage = currentPage + 1;
    });

    Future.delayed(Duration(milliseconds: 350), () {
      setState(() {
        _opacity = _opacity == 0.0 ? 1.0 : 0.0;
        if (currentPage == 1) {
          animationZeroCompleted = true;
          progress = 0.50;
        } else if (currentPage == 2) {
          progress = 0.75;
          animationOneCompleted = true;
        } else {
          Navigator.pushReplacement(
              context, FadeRouteBuilder(page: LoginPage()));
        }
      });
    });

    // if (currentPage != 2) {
    //   pageController.animateToPage(currentPage + 1,
    //       duration: Duration(milliseconds: 700), curve: Curves.easeIn);
    // }
  }
}
