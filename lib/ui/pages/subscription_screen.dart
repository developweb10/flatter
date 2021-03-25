import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:krushapp/utils/utils.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/krush_add_bloc/krush_add_bloc.dart';
import '../../bloc/request_action_bloc/request_action_bloc.dart';
import '../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
import '../../repositories/subscription_repository.dart';
import '../../utils/subsciption_painter_red.dart';
import '../../utils/subsciption_painter_white.dart';
import 'manage_subscription.dart';

class SubscriptionScreen extends StatefulWidget {
  Map args;
  SubscriptionScreen(this.args);

  @override
  State<StatefulWidget> createState() {
    return _SubscriptionScreenState();
  }
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  KrushAddBloc krushAddBloc;
  RequestActionBloc requestActionBloc;
  SubscriptionBlocBloc subscriptionBlocBloc;
  String subscription_status = "notPurchased";
  final SubscriptionRepository subscriptionRepository =
      SubscriptionRepository();
  InAppPurchaseConnection _connection;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = false;
  String _queryProductError;
  static const List<String> _kProductIds = <String>['krushin_sub_9.95'];
  String errorString;
  bool storeInfoInitiated = false;
  bool initStore;
  checkAndSubscribe() async {

    
     if(!storeInfoInitiated){
    setState(() {
      _loading = true;
    });
    _connection = InAppPurchaseConnection.instance;
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
      await initStoreInfo();

     }
    
  }

  @override
  void initState() {
    this.krushAddBloc = widget.args['krushAddBloc'];
    this.requestActionBloc = widget.args['requestActionBloc'];
    this.subscriptionBlocBloc = widget.args['subscriptionBlocBloc'];
    this.initStore = widget.args['initStore'];
    if(initStore){
      checkAndSubscribe();
    }
    
super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      // handle query past purchase error..
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    if(purchaseResponse.pastPurchases.length > 0){
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if(await UserSettingsManager.getSubscriptionTransactionID() != null){
        if((await UserSettingsManager.getSubscriptionTransactionID()) == purchase.purchaseID){
                verifiedPurchases.add(purchase);
                ProgressBar.client.showProgressBar(context);
                // bool valid = await subscriptionRepository.addSubscription("1", purchase.purchaseID, DateTime.fromMillisecondsSinceEpoch(int.parse(purchase.transactionDate)).toIso8601String());
                //   if (valid) {
                //     ProgressBar.client.dismissProgressBar();
                //     UserSettingsManager.setSubsciptionStatus(1);
                //   } else {
                //     ProgressBar.client.dismissProgressBar();
                //   }
              }else{
                setState(() {
                  errorString = "A subscription is already added for your play store email id for another account. Please select different email on play store.";
                });
                }
      }
      
    }
    }else{
      ProgressBar.client.showProgressBar(context);
          // bool valid = await subscriptionRepository.addSubscription("0", null, null);
          // if (valid) {
          //    ProgressBar.client.dismissProgressBar();
          //   UserSettingsManager.setSubsciptionStatus(0);
          // } else {
          //    ProgressBar.client.dismissProgressBar();
          // }
    }


    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _purchasePending = false;
      _loading = false;
      storeInfoInitiated = true;
    });

  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            errorString = "Unexpected error occured. Any amount deducted will be refunded within 3 days";
          });
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //   ProgressBar.client.showProgressBar(context);
          // bool valid = await subscriptionRepository.addSubscription("1", purchaseDetails.purchaseID, DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate)).toIso8601String() );
          // if (valid) {
          //    ProgressBar.client.dismissProgressBar();
          //   UserSettingsManager.setSubsciptionStatus(1);
          //   deliverProduct(purchaseDetails);
          // } else {
          //    ProgressBar.client.dismissProgressBar();
          //   _handleInvalidPurchase(purchaseDetails);
          //   return;
          // }
             
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }


  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase purchase details before delivering the product.
    InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });

    if (this.krushAddBloc != null) {
                      this.krushAddBloc.add(CheckAddKrush());
                      Navigator.pop(context);
                    } else if (this.requestActionBloc != null) {
                      this.requestActionBloc.add(CheckAcceptKrush());
                      Navigator.pop(context);
                    }
  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {
                    return Scaffold (
                      backgroundColor: Colors.redAccent,
                      body: Center(child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Text("Loading Store...", style: TextStyle(color: Colors.white,))
                      ],) ) ,
                    );
                  }else{
Map<String, PurchaseDetails> purchases = Map.fromEntries(
                      _purchases.map((PurchaseDetails purchase) {
                    if (purchase.pendingCompletePurchase) {
                      InAppPurchaseConnection.instance
                          .completePurchase(purchase);
                    }
                    return MapEntry<String, PurchaseDetails>(
                        purchase.productID, purchase);
                  }));

                  PurchaseDetails previousPurchase;
                  if (_products != null && _products.length>0) {
                    previousPurchase = purchases[_products[0].id];
                  }

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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          color:
                                              Colors.redAccent.withOpacity(0.6),
                                        )),
                                  ],
                                ),
                                Container(
                                    height: MediaQuery.of(context).size.height,
                                    // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2, left: MediaQuery.of(context).size.width*0.2),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.55,
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
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white
                                                            .withOpacity(0.9))),
                                              ]),
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,

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
                                                    // Text("\$09.",
                                                    //     style: TextStyle(
                                                    //         fontSize: 32,
                                                    //         fontWeight: FontWeight.w300,
                                                    //         color:
                                                    //             Colors.black.withOpacity(0.8))),
                                                    // SizedBox(
                                                    //   width: 5,
                                                    // ),
                                                    // Text("95",
                                                    //     style: TextStyle(
                                                    //         fontSize: 20,
                                                    //         fontWeight: FontWeight.w300,
                                                    //         color:
                                                    //             Colors.black.withOpacity(0.8))),
                                                    Text(
                                                      // _products[0].price
                                                      "\$9.99"
                                                      ,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8))),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 2,
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text("PER MONTH",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black
                                                            .withOpacity(0.8))),
                                              ],
                                            ),
                                            //  SizedBox(
                                            //       width: 60,
                                            //     ),
                                            Container(
                                              // color: Colors.green,
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
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "NO ADS",
                                                        style: Theme.of(context)
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
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "UNLIMITED KRUSH REQUESTS",
                                                        style: Theme.of(context)
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
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "90 DAY AUTO REVEALS FOR",
                                                        style: Theme.of(context)
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
                                                            "ALL OF YOUR KRUSHES",
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
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 8.0,
                                                        height: 8.0,
                                                        decoration:
                                                            new BoxDecoration(
                                                          color:
                                                              Colors.redAccent,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "CANCEL ANYTIME",
                                                        style: Theme.of(context)
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
                                errorString == null ? Container():
                                Padding(padding: EdgeInsets.only(left: 10, right:10),
                                child:  Text(
                                                        errorString,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                      ),
                                ),
                                
            //                                              Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.end,
            //                                   children: [
            //                                   _purchasePending?  Center(
            //   child: CircularProgressIndicator(
                
            //   ),
            // ):
            //                                     previousPurchase != null
            //                                         ? RaisedButton(
            //                                             onPressed: () async {},
            //                                             elevation: 2,
            //                                             color: Colors.green,
            //                                             child: Text(
            //                                               "Subscribed",
            //                                               style: TextStyle(
            //                                                   color:
            //                                                       Colors.white),
            //                                             ),
            //                                             shape: RoundedRectangleBorder(
            //                                                 borderRadius:
            //                                                     BorderRadius
            //                                                         .circular(
            //                                                             5.0),
            //                                                 side: BorderSide(
            //                                                     color: Colors
            //                                                         .green)),
            //                                           )
            //                                         : RaisedButton(
            //                                             onPressed: () async {
            //                                             await checkAndSubscribe();
            //                                             if(_products != null && _products.length>0){
            //                                                   PurchaseParam
            //                                                   purchaseParam =
            //                                                   PurchaseParam(
            //                                                       productDetails:
            //                                                           _products[0],
            //                                                       applicationUserName:
            //                                                           null,
            //                                                       sandboxTesting:
            //                                                           true);
            //                                               _connection
            //                                                   .buyNonConsumable(
            //                                                       purchaseParam:
            //                                                           purchaseParam);
            //                                             }
                                                        
            //                                               // this.subscriptionBlocBloc.add(AddSubscription());
            //                                             },
            //                                             elevation: 2,
            //                                             color: Theme.of(context)
            //                                                 .accentColor,
            //                                             child: Text(
            //                                               "BUY",
            //                                               style: TextStyle(
            //                                                   color:
            //                                                       Colors.white),
            //                                             ),
            //                                             shape: RoundedRectangleBorder(
            //                                                 borderRadius:
            //                                                     BorderRadius
            //                                                         .circular(
            //                                                             5.0),
            //                                                 side: BorderSide(
            //                                                     color: Colors
            //                                                         .red)),
            //                                           )
            //                                   ],
            //                                 ),

            RaisedButton(
                                                        onPressed: () async {
                                                        // await checkAndSubscribe();
                                                        // if(_products != null && _products.length>0){
                                                        //       PurchaseParam
                                                        //       purchaseParam =
                                                        //       PurchaseParam(
                                                        //           productDetails:
                                                        //               _products[0],
                                                        //           applicationUserName:
                                                        //               null,
                                                        //           sandboxTesting:
                                                        //               true);
                                                        //   _connection
                                                        //       .buyNonConsumable(
                                                        //           purchaseParam:
                                                        //               purchaseParam);
                                                        // }
                                                        
                                                        //   // this.subscriptionBlocBloc.add(AddSubscription());
// Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => ManageSubscription()),
//   );  
                                                        },
                                                        elevation: 2,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        child: Text(
                                                          "BUY",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                                    top: MediaQuery.of(context).size.height *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,

                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 28.0,
                                          height: 28.0,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.white,
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
                        )
                    )
              
            );
                  }
  }
}
