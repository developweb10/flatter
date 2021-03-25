import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/utils/Constants.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/ads_bloc/ads_bloc.dart';
import '../../../bloc/krush_add_bloc/krush_add_bloc.dart';
import '../../../bloc/request_action_bloc/request_action_bloc.dart';
import '../../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
import '../../../repositories/subscription_repository.dart';
import 'proscreen.dart';
import '../../../utils/subsciption_painter_red.dart';
import '../../../utils/subsciption_painter_white.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components.dart';

PurchaserInfo _purchaserInfo;

class ManageSubscriptionRevenuecat extends StatefulWidget {
  bool fromAddDialog;
  bool fromAcceptDialog;

  ManageSubscriptionRevenuecat({this.fromAddDialog, this.fromAcceptDialog});
  @override
  State<StatefulWidget> createState() {
    return _ManageSubscriptionRevenuecatState();
  }
}

class _ManageSubscriptionRevenuecatState
    extends State<ManageSubscriptionRevenuecat>
    with SingleTickerProviderStateMixin {
  final SubscriptionRepository subscriptionRepository =
      SubscriptionRepository();
  String errorString;
  Offerings _offerings;
  bool _loading = true;
  EntitlementInfo purchaseEntitlementInfo;

  @override
  void initState() {
    initPlatformState();
    
    super.initState();
  }

  Future<void> fetchData() async {
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  Future<void> initPlatformState() async {
    appData.status = "unsubscribed";

    await Purchases.setDebugLogsEnabled(!Constants.production);
    await Purchases.setup(Constants.revenuecatAppId,
        appUserId: await UserSettingsManager.getUserPhone());

    fetchData();
    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());
      setState(() {
        _loading = false;
        purchaseEntitlementInfo =
            purchaserInfo.entitlements.all['Krushin Premium'];
      });

      if (purchaserInfo.entitlements.all['Krushin Premium'] != null &&
          purchaserInfo.entitlements.all['Krushin Premium'].isActive) {
        appData.status = 'subscribed';
        errorString = null;
        print("updating subs");
        context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription(
            "1", purchaserInfo.entitlements.all['Krushin Premium']));
      } else {
        context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription("0", null));
      }
    } on PlatformException catch (e) {
      print(e);
    }

    print('#### is user pro? ${appData.status}');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Loading Store...",
                style: TextStyle(
                  color: Colors.white,
                ))
          ],
        )),
      );
    } else {
      return Scaffold(
          body: BlocConsumer(
        listener: (context, state) {
          if (state is SubscriptionStatus) {
            print("state.isSubscribed" + state.isSubscribed.toString());
            context.bloc<AdsBloc>().add(CheckToShowAd());
            if (state.isSubscribed) {
              setState(() {
                appData.status = "subscribed";
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PremiumScreen(state.purchaseDetails)),
              );
            } else {
              setState(() {
                appData.status = "unsubscribed";
              });
            }

            if (widget.fromAcceptDialog == true) {
              context.bloc<RequestActionBloc>().add(CheckAcceptKrush());
            } else if (widget.fromAddDialog == true) {
              context.bloc<KrushAddBloc>().add(CheckAddKrush());
            }
          }
        },
        cubit: context.bloc<SubscriptionBlocBloc>(),
        builder: (context, state) {
          return Container(
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
                                                    fontWeight: FontWeight.w300,
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
                                          color: Colors.black.withOpacity(0.9),
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
                                    state is SubscriptionsLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.red,
                                            ),
                                          )
                                        : appData.status == 'pending'
                                            ? Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'We noticed, there is a pending purchase for \nyour subscription.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2
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
                                                      'Complete the purchase before the grace \nperiod is expired.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2
                                                          .apply(
                                                              color: Colors
                                                                  .redAccent),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.2),
                                                child: Column(
                                                  children: [
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
                                                          "NO ADS",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
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
                                                          "UNLIMITED KRUSH REQUESTS",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
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
                                                          "BLOCK KRUSH REQUESTS FROM",
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
                                                              "ANYONE",
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
                                                    // Row(
                                                    //   children: [
                                                    //     Container(
                                                    //       width: 8.0,
                                                    //       height: 8.0,
                                                    //       decoration:
                                                    //           new BoxDecoration(
                                                    //         color: Colors
                                                    //             .redAccent,
                                                    //         shape:
                                                    //             BoxShape.circle,
                                                    //       ),
                                                    //     ),
                                                    //     SizedBox(
                                                    //       width: 10,
                                                    //     ),
                                                    //     Text(
                                                    //       "90 DAY AUTO REVEALS FOR",
                                                    //       style: Theme.of(
                                                    //               context)
                                                    //           .textTheme
                                                    //           .subtitle2
                                                    //           .apply(
                                                    //               color: Colors
                                                    //                   .redAccent),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    // Row(
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .start,
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
                                                    //           CrossAxisAlignment
                                                    //               .start,
                                                    //       children: [
                                                    //         Text(
                                                    //           "ALL OF YOUR KRUSHES",
                                                    //           style: Theme.of(
                                                    //                   context)
                                                    //               .textTheme
                                                    //               .subtitle2
                                                    //               .apply(
                                                    //                   color: Colors
                                                    //                       .redAccent),
                                                    //         )
                                                    //       ],
                                                    //     )
                                                    //   ],
                                                    // ),
                                                    // SizedBox(
                                                    //   height: 10,
                                                    // ),
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
                                                          "CANCEL ANYTIME",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2
                                                              .apply(
                                                                  color: Colors
                                                                      .redAccent),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                    Column(
                                      children: [
                                        errorString == null
                                            ? Container()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Text(
                                                  errorString,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            appData.status == "pending"
                                                ? RaisedButton(
                                                    onPressed: () async {
                                                      // deliverProduct(
                                                      //     purchaseDetails_pending);
                                                    },
                                                    elevation: 2,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    child: Text(
                                                      "Confirm Purchase",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .red)),
                                                  )
                                                : RaisedButton(
                                                    onPressed: () async {
                                                      try {
                                                        print(
                                                            'now trying to purchase');
                                                        _purchaserInfo =
                                                            await Purchases
                                                                .purchasePackage(
                                                                    _offerings
                                                                        .current
                                                                        .monthly);
                                                        print(
                                                            'purchase completed');
                                                        print(_purchaserInfo
                                                            .entitlements.all);
                                                        if (_purchaserInfo
                                                                    .entitlements
                                                                    .all[
                                                                "Krushin Premium"] !=
                                                            null) {
                                                          if (_purchaserInfo
                                                              .entitlements
                                                              .all[
                                                                  "Krushin Premium"]
                                                              .isActive) {
                                                            setState(() {
                                                              appData.status =
                                                                  "subscribed";
                                                            });
                                                            context
                                                                .bloc<
                                                                    SubscriptionBlocBloc>()
                                                                .add(UpdateSubscription(
                                                                    "1",
                                                                    _purchaserInfo
                                                                        .entitlements
                                                                        .all["Krushin Premium"]));
                                                            // Navigator
                                                            //     .pushReplacement(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //       builder: (context) =>
                                                            //           PremiumScreen(_purchaserInfo
                                                            //               .entitlements
                                                            //               .all["Krushin Premium"])),
                                                            // );
                                                          } else {
                                                            setState(() {
                                                              appData.status =
                                                                  "unsubscribed";
                                                              errorString =
                                                                  "Unexpected error occured. Any amount deducted will be refunded within 3 days";
                                                            });
                                                          }
                                                        }
                                                      } on PlatformException catch (e) {
                                                        print('----xx-----');
                                                        var errorCode =
                                                            PurchasesErrorHelper
                                                                .getErrorCode(
                                                                    e);
                                                        if (errorCode ==
                                                            PurchasesErrorCode
                                                                .purchaseCancelledError) {
                                                          setState(() {
                                                            errorString =
                                                                "User cancelled";
                                                          });
                                                        } else if (errorCode ==
                                                            PurchasesErrorCode
                                                                .purchaseNotAllowedError) {
                                                          setState(() {
                                                            errorString =
                                                                "User not allowed to purchase";
                                                          });
                                                        }
                                                      }
                                                      // return UpgradeScreen();
                                                    },
                                                    elevation: 2,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    child: Text(
                                                      "SUBSCRIBE",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
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
              ));
        },
      ));
    }
  }
}
