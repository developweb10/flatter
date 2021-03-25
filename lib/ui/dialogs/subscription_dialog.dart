import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/ui/pages/subscriptions_revenuecat/manage_subscription_revenuecat.dart';
import '../pages/manage_subscription.dart';
import '../../utils/subsciption_painter_red.dart';
import '../../utils/subsciption_painter_white.dart';

class SubscriptionDialog extends StatelessWidget {
  String transactionId;
  SubscriptionDialog(this.transactionId);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
        child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Stack(children: [
                  Stack(
                    children: [
                      Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ))),
                          ClipPath(
                            clipper: SubscriptionPainterWhite(),
                            child: Container(
                              color: Colors.white,
                              // child: Text("data"),
                            ),
                          ),
                          ClipPath(
                              clipper: SubscriptionPainterRed(),
                              child: Container(
                                color: Colors.redAccent.withOpacity(0.6),
                              )),
                        ],
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height,
                          // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2, left: MediaQuery.of(context).size.width*0.2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
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
                                 Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("\$9.99",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black
                                                          .withOpacity(0.8))),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            height: 25,
                                            width: 2,
                                            color:
                                                Colors.black.withOpacity(0.9),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text("PER MONTH",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black
                                                      .withOpacity(0.8))),
                                        ],
                                      ),
                                  //  SizedBox(
                                  //       width: 60,
                                  //     ),

                                  this.transactionId != null ?
                                                     Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'We noticed a change in your subscription status.',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .redAccent),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Please confirm the status.',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .redAccent),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : 
                                  Container(
                                    // color: Colors.green,
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.12),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "No ads".toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .apply(
                                                      color: Colors.redAccent),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Unlimited krush requests".toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .apply(
                                                      color: Colors.redAccent),
                                            )
                                          ],
                                        ),

                                        SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 8.0,
                                                          height: 8.0,
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "BLOCK KRUSH REQUESTS".toUpperCase(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 8.0,
                                                          height: 8.0,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "FROM ANYONE".toUpperCase(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle2
                                                                  .apply(
                                                                      color: Colors
                                                                          .redAccent),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Container(
                                        //       width: 8.0,
                                        //       height: 8.0,
                                        //       decoration: new BoxDecoration(
                                        //         color: Colors.redAccent,
                                        //         shape: BoxShape.circle,
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     Text(
                                        //       "90 day auto reveal for",
                                        //       style: Theme.of(context)
                                        //           .textTheme
                                        //           .subtitle2
                                        //           .apply(
                                        //               color: Colors.redAccent),
                                        //     ),
                                        //   ],
                                        // ),
                                        // Row(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Container(
                                        //       width: 8.0,
                                        //       height: 8.0,
                                        //     ),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //     Column(
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment.start,
                                        //       children: [
                                        //         Text(
                                        //           "all your krushes",
                                        //           style: Theme.of(context)
                                        //               .textTheme
                                        //               .subtitle2
                                        //               .apply(
                                        //                   color:
                                        //                       Colors.redAccent),
                                        //         )
                                        //       ],
                                        //     )
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: new BoxDecoration(
                                                color: Colors.redAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Cancel anytime".toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .apply(
                                                      color: Colors.redAccent),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                       RaisedButton(
                                        onPressed: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => ManageSubscriptionRevenuecat()),
                                        );  

                                        },
                                        elevation: 2,
                                        color: Theme.of(context).accentColor,
                                        child: Text(
                                          this.transactionId != null ? "CONFIRM STATUS" : "SUBSCRIBE",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side:
                                                BorderSide(color: Colors.red)),
                                      )
                                    ],
                                  ),
                                ],
                              ))
                            ],
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, right: 20),
                            child: Container(
                                width: 28.0,
                                height: 28.0,
                                decoration: new BoxDecoration(
                                  // color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                )),
                          )),
                    ],
                  )
                ]),
              ));
  }
}
