import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThirdImage extends StatelessWidget {
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
                                child: Container(
              height: screenHeight * 0.50,
              child:
                  Image.asset('assets/images/screen3_background.png',fit: BoxFit.cover,),
                          ),
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
                    Positioned(
                      top: screenHeight * 0.1,
                      left: screenWidth * 0.3,
                      child: Container(
                        //  margin: EdgeInsets.only(top: screenHeight*0.40),
                        child: Image.asset(
                          'assets/images/screen3_security.png',
                          height: screenHeight / 2.5,
                          width: screenWidth / 2.5,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                        child: Container(
                        
                        child: Image.asset('assets/images/screen3_cloud.png'),
                      ),
                    ),
                  ],
                ),
              Positioned(
                          bottom: screenHeight * 0.30,
                          right: -10,
                          child: Container(
                            child: Image.asset('assets/images/screen3_cricle.png',
                            height: 0.12*screenHeight,
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

class ThirdText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Safety",
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          "The safe use of our application and",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "protection of our users is critically",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Text(
          "important to us.",
          style: Theme.of(context).textTheme.subtitle1,
        )
      ],
    );
  }
}
