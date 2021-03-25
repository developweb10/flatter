import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:krushapp/utils/subsciption_painter_red.dart';
import 'package:krushapp/utils/subsciption_painter_white.dart';
import 'package:purchases_flutter/entitlement_info_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components.dart';

class PremiumScreen extends StatelessWidget {

  EntitlementInfo purchaseEntitlementInfo;

  PremiumScreen(this.purchaseEntitlementInfo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              // decoration: backgroundDecoration,
              child: Stack(
                children: [
                  Stack(children: [
                    Stack(
                      children: [
                        Stack(
                          children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ))),
                            ClipPath(
                              clipper: SubscriptionPainterWhite(),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.redAccent,
                                    ))),
                            ClipPath(
                                clipper: SubscriptionPainterRed(),
                                child: Container(
                                  color: Colors.redAccent.withOpacity(0.6),
                                )),
                          ],
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: SvgPicture.asset(
                                              'assets/svg/krushin_logo.svg'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Premium",
                                            style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white
                                                    .withOpacity(0.9))),
                                      ]),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                 
                                    Column(
                                      children: [
                                      Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'You are a premium subscriber',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline4
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'Enjoy the benefits.',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          getRenewalTimeString(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .apply(
                                                                  color: Colors
                                                                      .black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                             RaisedButton(
                                                            onPressed:
                                                                () async {
await launch(
                                                              getSubscriptionDeepLink());
                                                            },
                                                            elevation: 2,
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            child: Text(
                                                              "MANAGE SUBSCRIPTIONS",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .red)),
                                                          )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ))
                      ],
                    ),
                  ]),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )));
  }

    String getRenewalTimeString() {
    if(purchaseEntitlementInfo == null)
    return "";

    var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(purchaseEntitlementInfo.expirationDate, true);
    DateTime date = dateTime.toLocal();
    
    // DateTime date = DateTime.parse(purchaseEntitlementInfo.expirationDate);
    String toReturn = purchaseEntitlementInfo.willRenew ? "Renews on " : "Cancels on ";
    
    String hour = (date.hour >= 12) ? (date.hour-12).toString() : date.hour.toString();
    String amPM = (date.hour >= 12) ? " PM" : " AM";
    String minute = date.minute < 10 ? "0"+ date.minute.toString() : date.minute.toString();
      
          toReturn = toReturn +
        date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString() +
        " at " +
         hour +
        "." +
        minute
        
        + amPM;

    return toReturn;
  }

    String getSubscriptionDeepLink() {
    String packageName = "io.krushin.app";
    String sku = "krushin_sub_9.95";
    if (Platform.isIOS)
      return "https://apps.apple.com/account/subscriptions";
    else if (Platform.isAndroid)
      return "https://play.google.com/store/account/subscriptions?sku=$sku&package=$packageName";
    else
      return "";
  }
}