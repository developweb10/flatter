// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import '../../bloc/krush_add_bloc/krush_add_bloc.dart';
// import '../../bloc/request_action_bloc/request_action_bloc.dart';
// import '../../bloc/ads_bloc/ads_bloc.dart';
// import '../../bloc/subscription_bloc/subscription_bloc_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../app/shared_prefrence.dart';
// import '../../repositories/subscription_repository.dart';
// import '../../utils/subsciption_painter_red.dart';
// import '../../utils/subsciption_painter_white.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ManageSubscription extends StatefulWidget {
//   bool fromAddDialog;
//   bool fromAcceptDialog;

//   ManageSubscription({this.fromAddDialog, this.fromAcceptDialog});
//   @override
//   State<StatefulWidget> createState() {
//     return _ManageSubscriptionState();
//   }
// }

// class _ManageSubscriptionState extends State<ManageSubscription>
//     with SingleTickerProviderStateMixin {
//   String subscription_status = "notSubscribed";
//   final SubscriptionRepository subscriptionRepository =
//       SubscriptionRepository();
//   InAppPurchaseConnection _connection;
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = false;
//   static const List<String> _kProductIds = <String>['krushin_sub_9.95'];
//   String errorString;
//   bool storeInfoInitiated = false;
//   String original_purchase_id;
//   String subscription_expiry_date;
//   bool isAutoRenewing = false;
//   PurchaseDetails purchaseDetails_pending;

//   @override
//   void initState() {
//     _connection = InAppPurchaseConnection.instance;
//     Stream purchaseUpdated =
//         InAppPurchaseConnection.instance.purchaseUpdatedStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {});

//     initStoreInfo();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   Future<void> initStoreInfo() async {
//     setState(() {
//       _loading = true;
//     });
//     final bool isAvailable = await _connection.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     ProductDetailsResponse productDetailResponse =
//         await _connection.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     if (productDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = productDetailResponse.productDetails;
//         _purchases = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();
//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }

//     final List<PurchaseDetails> verifiedPurchases = [];
//     String transactionIDFromServer = await UserSettingsManager.getSubscriptionTransactionID();
//     print(purchaseResponse.pastPurchases.length);
//     if (purchaseResponse.pastPurchases.length > 0) {
   
//     if(Platform.isIOS){
//       DateTime expriry_date = DateTime(2000);
//       int latestPurchaseIndex = 0;
//       int index = 0;
//         for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//               if (purchase.pendingCompletePurchase) {
//                 setState(() {
//               subscription_status = "pending";
//               purchaseDetails_pending = purchase;
//             });

//             break;
//       // InAppPurchaseConnection.instance.completePurchase(purchase);
//     }
//         index += 1;
//         DateTime current_date = DateTime.fromMillisecondsSinceEpoch(int.parse(purchase.transactionDate));

//         if(current_date.isAfter(expriry_date)){
//           expriry_date = current_date;
//           latestPurchaseIndex = index;
//         }
//       };


//       PurchaseDetails purchase = purchaseResponse.pastPurchases[latestPurchaseIndex];
//       if (transactionIDFromServer == null) {
//           if (purchase.status == PurchaseStatus.pending) {
//             setState(() {
//               subscription_status = "pending";
//               purchaseDetails_pending = purchase;
//             });
//           }
//         } else if (purchase.status == PurchaseStatus.purchased) {
        
//          if (purchase.verificationData.localVerificationData == null)
//                 _connection.refreshPurchaseVerificationData();

//               var verificationJson =
//                   await subscriptionRepository.getVerificationDataJson(
//                       purchase.verificationData.localVerificationData);
//               var newJson = jsonDecode(verificationJson['data']['data']);
//               setState(() {
//                 original_purchase_id = newJson['latest_receipt_info'][0]
//                     ['original_transaction_id'];
//                 subscription_expiry_date = DateTime.fromMillisecondsSinceEpoch(
//                         int.parse(newJson['latest_receipt_info'][0]
//                             ['expires_date_ms']))
//                     .toIso8601String();
//                 isAutoRenewing = newJson['pending_renewal_info'][0]
//                             ['auto_renew_status'] ==
//                         "1"
//                     ? true
//                     : false;
//               });

//       if (transactionIDFromServer == original_purchase_id) {
              
//               // context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription("1",
//               //     purchase, original_purchase_id, subscription_expiry_date));
//             } else {
//               setState(() {
//                 errorString =
//                     "A subscription is already added from your store email id for another account. Please select different account on store.";
//               });
//             }

//       }


//     } else if(Platform.isAndroid){
//             for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//         if (transactionIDFromServer == null) {
//           if (purchase.status == PurchaseStatus.pending) {
//             setState(() {
//               subscription_status = "pending";
//             });
//           }
//         } else {
//           if (purchase.status == PurchaseStatus.purchased) {
//               print(purchase.verificationData.localVerificationData);
//               DateTime original_transaction_date =
//                   DateTime.fromMillisecondsSinceEpoch(
//                       int.parse(purchase.transactionDate));
//               DateTime temp_expiry_date = original_transaction_date;
//               while (temp_expiry_date.isBefore(DateTime.now())) {
//                 temp_expiry_date = temp_expiry_date.add(Duration(minutes: 5));
//               }

//               setState(() {
//                 original_purchase_id = purchase.purchaseID;
//                 subscription_expiry_date = temp_expiry_date.toIso8601String();
//                 isAutoRenewing =
//                     jsonDecode(purchase.verificationData.localVerificationData)[
//                         'autoRenewing'];
//               });
            

//             if (transactionIDFromServer == original_purchase_id) {
//               verifiedPurchases.add(purchase);

//                       if(DateTime.parse(subscription_expiry_date).isBefore(DateTime.now())){
//           //  context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription("0",
//           //   null, null, null));
//         }else{
//           // context.bloc<SubscriptionBlocBloc>().add(AddSubscription("1",
//           //   purchase, original_purchase_id, subscription_expiry_date));
//         }
//             } else {
//               setState(() {
//                 errorString =
//                     "A subscription is already added from your store email id for another account. Please select different account on store.";
//               });
//             }
//           }
//         }
        
//       }
//     }
    

//     } else {
//       if (await UserSettingsManager.getSubsciptionStatus() == 0) {
//         // context
//         //     .bloc<SubscriptionBlocBloc>()
//         //     .add(UpdateSubscription("0", null, null, null));
//       } else {
//         setState(() {
//           subscription_status = 'Subscribed';
//         });
//       }
//     }

//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       _purchasePending = false;
//       _loading = false;
//       storeInfoInitiated = true;
//     });
//   }

//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
 
//     if(Platform.isIOS){
//       DateTime expriry_date = DateTime(2000);
//       int latestPurchaseIndex = 0;
//       int index = 0;
//       purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//     //        if (purchaseDetails.pendingCompletePurchase) {
//     //   InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
//     // }
//         index += 1;
//         DateTime current_date = DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate));

//         if(current_date.isAfter(expriry_date)){
//           expriry_date = current_date;
//           latestPurchaseIndex = index;
//         }
//       });


//       PurchaseDetails purchaseDetails = purchaseDetailsList[latestPurchaseIndex];
//       if (purchaseDetails.status == PurchaseStatus.error) {
//         setState(() {
//           errorString =
//               "Unexpected error occured. Any amount deducted will be refunded within 3 days";
//         });
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//           purchaseDetails.status == PurchaseStatus.pending) {
        
//           if (purchaseDetails.verificationData.localVerificationData == null)
//             _connection.refreshPurchaseVerificationData();

//           var verificationJson = await subscriptionRepository.getVerificationDataJson(
//                   purchaseDetails.verificationData.localVerificationData);
//           var newJson = jsonDecode(verificationJson['data']['data']);
//           setState(() {
//             original_purchase_id =
//                 newJson['latest_receipt_info'][0]['original_transaction_id'];
//             subscription_expiry_date = DateTime.fromMillisecondsSinceEpoch(
//                     int.parse(
//                         newJson['latest_receipt_info'][0]['expires_date_ms']))
//                 .toIso8601String();
//             isAutoRenewing =
//                 newJson['pending_renewal_info'][0]['auto_renew_status'] == "1"
//                     ? true
//                     : false;
//           });
      
//         // if(DateTime.parse(subscription_expiry_date).isBefore(DateTime.now())){
//         //    context.bloc<SubscriptionBlocBloc>().add(UpdateSubscription("0",
//         //     null, null, null));
//         // }else{
//         //   context.bloc<SubscriptionBlocBloc>().add(AddSubscription("1",
//         //     purchaseDetails, original_purchase_id, subscription_expiry_date));
//         // }

        

//       }


//     }else if(Platform.isAndroid){
//           purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//             print("running for each");
//       if (purchaseDetails.status == PurchaseStatus.error) {
//         setState(() {
//           errorString =
//               "Unexpected error occured. Any amount deducted will be refunded within 3 days";
//         });
//       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//           purchaseDetails.status == PurchaseStatus.pending) {
//           print(purchaseDetails.verificationData.localVerificationData);
//           DateTime original_transaction_date =
//               DateTime.fromMillisecondsSinceEpoch(
//                   int.parse(purchaseDetails.transactionDate));
//           DateTime temp_expiry_date = original_transaction_date;

//           try {
//             while (temp_expiry_date.isBefore(DateTime.now())) {
//               temp_expiry_date = temp_expiry_date.add(Duration(minutes: 5));
//             }
//             setState(() {
//               original_purchase_id = purchaseDetails.purchaseID;
//               subscription_expiry_date = temp_expiry_date.toIso8601String();
//               isAutoRenewing = jsonDecode(purchaseDetails
//                   .verificationData.localVerificationData)['autoRenewing'];
//             });
//           } catch (e) {
//             print(e.toString());
//           }

//         // context.bloc<SubscriptionBlocBloc>().add(AddSubscription("1",
//         //     purchaseDetails, original_purchase_id, subscription_expiry_date));
//       }
//     });
//     }

//   }

  

//   void showPendingUI() {
//     setState(() {
//       _purchasePending = true;
//     });
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//   }

//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     if (purchaseDetails.pendingCompletePurchase) {
//       InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
//     }
//     setState(() {
//       _purchases.clear();
//       _purchases.add(purchaseDetails);
//       _purchasePending = false;
//       subscription_status = "Subscribed";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         backgroundColor: Colors.redAccent,
//         body: Center(
//             child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(
//               backgroundColor: Colors.white,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text("Loading Store...",
//                 style: TextStyle(
//                   color: Colors.white,
//                 ))
//           ],
//         )),
//       );
//     } else {
//       Map<String, PurchaseDetails> purchases = 
//           Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//         if (purchase.pendingCompletePurchase) {
//           InAppPurchaseConnection.instance.completePurchase(purchase);
//         }
//         return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//       }));

//       PurchaseDetails previousPurchase;
//       if (_products != null && _products.length > 0) {
//         previousPurchase = purchases[_products[0].id];
//       }

//       return Scaffold(
//           body: BlocConsumer(
//         listener: (context, state) {
//           if (state is SubscriptionStatus) {
//             context.bloc<AdsBloc>().add(CheckToShowAd());
//             if (state.isSubscribed) {
//               setState(() {
//                 subscription_status = "Subscribed";
//               });
//             } else {
//               setState(() {
//                 subscription_status = "unSubscribed";
//               });
//             }
//           } else if (state is SubscriptionAdded) {
//             if (state.isSubscribed) {
//               // deliverProduct(state.purchaseDetails);
//               context.bloc<AdsBloc>().add(CheckToShowAd());

//               if (widget.fromAcceptDialog == true) {
//                 context.bloc<RequestActionBloc>().add(CheckAcceptKrush());
//               } else if (widget.fromAddDialog == true) {
//                 context.bloc<KrushAddBloc>().add(CheckAddKrush());
//               }
//             }
//           }
//         },
//         cubit: context.bloc<SubscriptionBlocBloc>(),
//         builder: (context, state) {
//           return Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.redAccent,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               // decoration: backgroundDecoration,
//               child: Stack(
//                 children: [
//                   Stack(children: [
//                     Stack(
//                       children: [
//                         Stack(
//                           children: [
//                             Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Container(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.2,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white,
//                                     ))),
//                             ClipPath(
//                               clipper: SubscriptionPainterWhite(),
//                               child: Container(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Align(
//                                 alignment: Alignment.topCenter,
//                                 child: Container(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.2,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.redAccent,
//                                     ))),
//                             ClipPath(
//                                 clipper: SubscriptionPainterRed(),
//                                 child: Container(
//                                   color: Colors.redAccent.withOpacity(0.6),
//                                 )),
//                           ],
//                         ),
//                         Container(
//                             height: MediaQuery.of(context).size.height,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.55,
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                               0.15,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.25,
//                                           child: SvgPicture.asset(
//                                               'assets/svg/krushin_logo.svg'),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Text("Premium",
//                                             style: TextStyle(
//                                                 fontSize: 32,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: Colors.white
//                                                     .withOpacity(0.9))),
//                                       ]),
//                                 ),
//                                 Expanded(
//                                     child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   crossAxisAlignment: CrossAxisAlignment.center,

//                                   // mainAxisSize: MainAxisSize.max,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text("\$9.99",
//                                                 style: TextStyle(
//                                                     fontSize: 20,
//                                                     fontWeight: FontWeight.w300,
//                                                     color: Colors.black
//                                                         .withOpacity(0.8))),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           width: 15,
//                                         ),
//                                         Container(
//                                           height: 25,
//                                           width: 2,
//                                           color: Colors.black.withOpacity(0.9),
//                                         ),
//                                         SizedBox(
//                                           width: 15,
//                                         ),
//                                         Text("PER MONTH",
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.w300,
//                                                 color: Colors.black
//                                                     .withOpacity(0.8))),
//                                       ],
//                                     ),
//                                     state is SubscriptionsLoading
//                                         ? Center(
//                                             child: CircularProgressIndicator(
//                                               backgroundColor: Colors.red,
//                                             ),
//                                           )
//                                         : subscription_status == 'pending'
//                                             ? Container(
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       'We noticed, there is a pending purchase for \nyour subscription.',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .subtitle2
//                                                           .apply(
//                                                               color: Colors
//                                                                   .redAccent),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                     SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                     Text(
//                                                       'Complete the purchase before the grace \nperiod is expired.',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .subtitle2
//                                                           .apply(
//                                                               color: Colors
//                                                                   .redAccent),
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     )
//                                                   ],
//                                                 ),
//                                               )
//                                             : subscription_status ==
//                                                     'Subscribed'
//                                                 ? Container(
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Text(
//                                                           'You are a premium subscriber',
//                                                           style: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .headline4
//                                                               .apply(
//                                                                   color: Colors
//                                                                       .redAccent),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Text(
//                                                           'Enjoy the benefits.',
//                                                           style: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .headline6
//                                                               .apply(
//                                                                   color: Colors
//                                                                       .redAccent),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Text(
//                                                           getRenewalTimeString(),
//                                                           style: Theme.of(
//                                                                   context)
//                                                               .textTheme
//                                                               .headline6
//                                                               .apply(
//                                                                   color: Colors
//                                                                       .black),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )
//                                                 : Container(
//                                                     padding: EdgeInsets.only(
//                                                         left: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width *
//                                                             0.2),
//                                                     child: Column(
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               width: 8.0,
//                                                               height: 8.0,
//                                                               decoration:
//                                                                   new BoxDecoration(
//                                                                 color: Colors
//                                                                     .redAccent,
//                                                                 shape: BoxShape
//                                                                     .circle,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Text(
//                                                               "NO ADS",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .subtitle2
//                                                                   .apply(
//                                                                       color: Colors
//                                                                           .redAccent),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               width: 8.0,
//                                                               height: 8.0,
//                                                               decoration:
//                                                                   new BoxDecoration(
//                                                                 color: Colors
//                                                                     .redAccent,
//                                                                 shape: BoxShape
//                                                                     .circle,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Text(
//                                                               "UNLIMITED KRUSH REQUESTS",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .subtitle2
//                                                                   .apply(
//                                                                       color: Colors
//                                                                           .redAccent),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               width: 8.0,
//                                                               height: 8.0,
//                                                               decoration:
//                                                                   new BoxDecoration(
//                                                                 color: Colors
//                                                                     .redAccent,
//                                                                 shape: BoxShape
//                                                                     .circle,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Text(
//                                                               "90 DAY AUTO REVEALS FOR",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .subtitle2
//                                                                   .apply(
//                                                                       color: Colors
//                                                                           .redAccent),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Container(
//                                                               width: 8.0,
//                                                               height: 8.0,
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   "ALL OF YOUR KRUSHES",
//                                                                   style: Theme.of(
//                                                                           context)
//                                                                       .textTheme
//                                                                       .subtitle2
//                                                                       .apply(
//                                                                           color:
//                                                                               Colors.redAccent),
//                                                                 )
//                                                               ],
//                                                             )
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               width: 8.0,
//                                                               height: 8.0,
//                                                               decoration:
//                                                                   new BoxDecoration(
//                                                                 color: Colors
//                                                                     .redAccent,
//                                                                 shape: BoxShape
//                                                                     .circle,
//                                                               ),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Text(
//                                                               "CANCEL ANYTIME",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .subtitle2
//                                                                   .apply(
//                                                                       color: Colors
//                                                                           .redAccent),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                     Column(
//                                       children: [
//                                         errorString == null
//                                             ? Container()
//                                             : Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10, right: 10),
//                                                 child: Text(
//                                                   errorString,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodyText2,
//                                                 ),
//                                               ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             _purchasePending
//                                                 ? Center(
//                                                     child:
//                                                         CircularProgressIndicator(),
//                                                   )
//                                                 : subscription_status ==
//                                                         'Subscribed'
//                                                     ? RaisedButton(
//                                                         onPressed: () async {
//                                                           await launch(
//                                                               getSubscriptionDeepLink());
//                                                           initStoreInfo();
//                                                         },
//                                                         elevation: 2,
//                                                         color: Colors.redAccent,
//                                                         child: Text(
//                                                           "Manage Subscription",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white),
//                                                         ),
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         5.0),
//                                                             side: BorderSide(
//                                                                 color: Colors
//                                                                     .redAccent)),
//                                                       )
//                                                     : subscription_status ==
//                                                             "pending"
//                                                         ? RaisedButton(
//                                                             onPressed:
//                                                                 () async {
//                                                               deliverProduct(
//                                                                   purchaseDetails_pending);
//                                                             },
//                                                             elevation: 2,
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .accentColor,
//                                                             child: Text(
//                                                               "Confirm Purchase",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                             shape: RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5.0),
//                                                                 side: BorderSide(
//                                                                     color: Colors
//                                                                         .red)),
//                                                           )
//                                                         : RaisedButton(
//                                                             onPressed:
//                                                                 () async {
//                                                               if (_products !=
//                                                                       null &&
//                                                                   _products
//                                                                           .length >
//                                                                       0) {
//                                                                 PurchaseParam
//                                                                     purchaseParam =
//                                                                     PurchaseParam(
//                                                                         productDetails:
//                                                                             _products[
//                                                                                 0],
//                                                                         applicationUserName:
//                                                                             null,
//                                                                         sandboxTesting:
//                                                                             true);
//                                                                 _connection.buyNonConsumable(
//                                                                     purchaseParam:
//                                                                         purchaseParam);
//                                                               }
//                                                             },
//                                                             elevation: 2,
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .accentColor,
//                                                             child: Text(
//                                                               "SUBSCRIBE",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                             shape: RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5.0),
//                                                                 side: BorderSide(
//                                                                     color: Colors
//                                                                         .red)),
//                                                           )
//                                           ],
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ))
//                               ],
//                             ))
//                       ],
//                     ),
//                   ]),
//                   SafeArea(
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.height * 0.05,
//                         left: MediaQuery.of(context).size.width * 0.05,
//                       ),
//                       child: Row(
//                         // mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,

//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Container(
//                               width: 30.0,
//                               height: 30.0,
//                               decoration: new BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.arrow_back_ios_outlined,
//                                   color: Colors.redAccent,
//                                   size: 28,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ));
//         },
//       ));
//     }
//   }

//   String getSubscriptionDeepLink() {
//     String packageName = "io.krushin.app";
//     String sku = "krushin_sub_9.95";
//     if (Platform.isIOS)
//       return "https://apps.apple.com/account/subscriptions";
//     else if (Platform.isAndroid)
//       return "https://play.google.com/store/account/subscriptions?sku=$sku&package=$packageName";
//     else
//       return "";
//   }

//   String getRenewalTimeString() {
//     if(subscription_expiry_date == null)
//     return "";
//     DateTime date = DateTime.parse(subscription_expiry_date);
//     String toReturn = isAutoRenewing ? "Renews on " : "Expires on ";

//     toReturn = toReturn +
//         date.day.toString() +
//         "/" +
//         date.month.toString() +
//         "/" +
//         date.year.toString() +
//         " at " +
//         date.hour.toString() +
//         "." +
//         date.minute.toString();

//     return toReturn;
//   }
// }
