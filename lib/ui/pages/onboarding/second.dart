import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondImage extends StatelessWidget {
  double screenHeight;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        Container(
          height: screenHeight,
          child: Stack(
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: screenHeight * 0.15,
                                              child: Container(
                                                
                          // height: screenHeight*0.40,
                          // width: screenWidth,
                          child: Image.asset(
                            'assets/images/screen2_background.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.4,
                        child: Container(
                          height: screenHeight * 0.60,
                          child: Container(
                            height: screenHeight * 0.4,
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
                  Positioned(
                    bottom: 0.22 * (screenHeight * 0.60),
                    left: screenWidth * 0.03467,
                    right: 0,
                    child: Container(
                      child: Image.asset(
                        'assets/images/screen2_gift.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Image.asset('assets/images/screen2_cloud.png'),
                  ),
                ],
              ),
              Positioned(
                        bottom: screenHeight * 0.35,
                        right: -20,
                        child: Container(
                          child: Image.asset('assets/images/screen2_triangle.png',
                          height: 0.08*screenHeight,
                          ),
                        ),
                      ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecondText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Send Gifts",
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "Send gifts to, or receive",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "gifts from, your krush,",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "Your choice.",
          style: Theme.of(context).textTheme.subtitle1,
        )
      ],
    );
  }
}
