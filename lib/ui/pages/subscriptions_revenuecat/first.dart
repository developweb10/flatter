import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/utils/shapes.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'components.dart';

class First extends StatefulWidget {
  @override
  _KrushinPolicyState createState() => _KrushinPolicyState();
}

class _KrushinPolicyState extends State<First> {
 

   @override
  void initState() {

    super.initState();
  }






@override
Widget build(BuildContext context) {
  return TopBarAgnosticNoIcon(
    text: "widget.title",
    style: kSendButtonTextStyle,
    uniqueHeroTag: 'main',
    child: Scaffold(
      backgroundColor: kColorPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                'Welcome',
                style: kSendButtonTextStyle.copyWith(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton(
                  color: kColorAccent,
                  textColor: kColorText,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Purchase a subscription',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UpgradeScreen(), settings: RouteSettings(name: 'Upgrade screen')));

                  }),
            ),
          ],
        ),
      ),
    ),
  );
}
}