import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstImage extends StatelessWidget {
  double screenHeight;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Container(
            height: screenHeight,
            child: Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      //  height: screenHeight*0.40,
                      //  width: screenHeight*0.40,
                      child: Image.asset('assets/images/screen1_background.png'),
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        height: screenHeight * 0.60,
                        child: Container(
                          height: screenHeight * 0.45,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF217fc4), Colors.white])),
                        ),
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    Positioned(
                      top: screenHeight / 5,
                      left: screenWidth / 10,
                      child: Container(
                        //  margin: EdgeInsets.only(top: screenHeight*0.40),
                        child: Image.asset(
                          'assets/images/screen1_boy.png',
                          height: screenHeight / 2.5,
                          width: screenWidth / 2.5,
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight / 9,
                      right: screenWidth / 10,
                      child: Container(
                        //  margin: EdgeInsets.only(top: screenHeight*0.40),
                        child: Image.asset(
                          'assets/images/screen1_girl.png',
                          height: screenHeight / 2.5,
                          width: screenWidth / 2.5,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.40),
                      child: Image.asset('assets/images/screen1_cloud.png'),
                    ),
                    
                  ],
                ),
                Positioned(
                      top: screenHeight / 8,
                      right: 0,
                      child: Container(
                       margin: EdgeInsets.only(top: screenHeight * 0.40),
                        child: Image.asset('assets/images/screen1_ribbon.png'),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FirstText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Anonymous",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            "Anonymously chat to",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            "your krush and tell them",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            "how you feel.",
            style: Theme.of(context).textTheme.subtitle1,
          )
        ],
      ),
    );
  }
}
