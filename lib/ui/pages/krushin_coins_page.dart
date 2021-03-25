import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/krushin_coins_bloc/krushin_coins_bloc.dart';
import 'package:krushapp/bloc/transactions_bloc/transactions_bloc.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import 'package:krushapp/ui/pages/payment_page.dart';
import 'package:krushapp/utils/T.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io' show Platform;

const String testDevice = '';

class KrushinCoinsPage extends StatefulWidget {
  String prevPage;
  String mobileNumber;

  KrushinCoinsPage({this.prevPage, this.mobileNumber});
  @override
  _KrushinCoinsPageState createState() => _KrushinCoinsPageState();
}

class _KrushinCoinsPageState extends State<KrushinCoinsPage> {
  int coin_number = 0;
  String token = "";
  String stripeId;
  List transactions;
  bool _loadingTransactions;
  bool _loading = true;
  bool loaded = false;
  bool toShow = false;
  Function wp;

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    // testDevices: <String>["D6C28ED1C5FB3C8CB2367012028903F7"],
    // keywords: <String>['wallpapers', 'walls', 'amoled'],
    childDirected: false,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  int _coins = 0;

  AdsRepository adsRepository;
  RewardedVideoAd videoAd = RewardedVideoAd.instance;
   AdsBloc adsBloc;
  KrushinCoinsBloc krushinCoinsBloc = KrushinCoinsBloc();
  TransactionsBloc transactionsBloc = TransactionsBloc();

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetInfo,
      listener: (MobileAdEvent event) {
      },
    );
  }

  void setError(dynamic error) {
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Error loading ad";
        String message =
            "You have exceeds the daily limit to view ads";
        String btnLabel = "OK";
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
      
            FlatButton(
                child: Text(
                  btnLabel,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontFamily: "openSans",
                      fontSize: 16),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }





  initiateTransaction(BuildContext context, int coins, double dollars) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(coins: coins, dollars: dollars, krushinCoinsBloc: krushinCoinsBloc,)));
 
    //  addCoins(coins);
  }





  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-9307372028212142/7864496312";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9307372028212142/8011835977";
    }
    return null;
  }





  @override
  void initState() {
    // TODO: implement initState
 
    adsRepository = AdsRepository(adsBloc,videoAd, krushinCoinsBloc);

 
    super.initState();
    krushinCoinsBloc.add(GetCoins());
    transactionsBloc.add(TransactionAdded());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            child: AppBar(), preferredSize: Size(context.screenWidth, 0.0)),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[

              BlocBuilder(
                cubit:  krushinCoinsBloc,
                builder: (context, state) {
                  if(state is CoinsAdded){
                    coin_number = state.coins_count;
                  }

                  return SliverAppBar(
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                        bottom: kToolbarHeight,
                        top: kToolbarHeight),
                    child: Card(
                      
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        // height: MediaQuery.of(context).size.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset('assets/images/coins_stack.png'),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Coins Balance',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),

                                  state is CoinsAdding ?
                                    Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ) : state is CoinsAddingFailed ? Text("error") : 
                                  
                                  Text(
                                    '${coin_number.toString()} Krushin Coins',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
                bottom: TabBar(tabs: [
                  Tab(
                    text: 'Get Coins',
                  ),
                  Tab(
                    text: 'Transactions',
                  )
                ]),
                title: Text('KRUSHIN COINS'),
                expandedHeight: context.screenHeight * 0.3,
              );
                }, 
              ),
              
              SliverFillRemaining(
                child: TabBarView(children: [
                  getCoinsTab(),
                  _loadingTransactions
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        )
                      : getTransactionTab(),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

 

  Widget getCoinsTab() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      children: <Widget>[

       BlocBuilder(
    cubit: adsBloc,
    builder: (BuildContext context, AdsState state) {
return InkWell(
          onTap: () async {


          },
          child: Card(
            margin: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.video_library,
                    color: Colors.white,
                  ),
                  Text(
                    'Watch Ad and earn 50 Krushin Coins',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );

    }),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Divider(
              height: 1,
              thickness: 1,
            ),
            Text('OR'),
            Divider(
              height: 1,
              thickness: 1,
            )
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
          child: Text(
            'Buy Krushin Coins',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ...[
          InkWell(
            onTap: (){
                initiateTransaction(context, 1000, 4.99);
            },
            child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              trailing: FlatButton(
                  onPressed: () {
                            initiateTransaction(context, 1000, 4.99);
                  },
                  child: Text('Buy')),
              title: Text('1000 Krushin Coins'),
              subtitle: Text('\$ 4.99'),
              leading: Image.asset(
                'assets/images/coins_small.png',
                width: 32,
              ),
            ),
          ),
          ),
          InkWell(
            onTap: (){
 initiateTransaction(context, 2300, 9.99);
            },
            child:   Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              trailing: FlatButton(
                  onPressed: () {
                    initiateTransaction(context, 2300, 9.99);
                  },
                  child: Text('Buy')),
              title: Text('2300 Krushin Coins'),
              subtitle: Text('\$9.99'),
              leading: Image.asset(
                'assets/images/coins_medium.png',
                width: 32,
              ),
            ),
          ), 
          ),

          InkWell(
            onTap: (){
initiateTransaction(context, 5000, 19.99);
            },
            child:  Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              trailing: FlatButton(
                  onPressed: () {
                    initiateTransaction(context, 5000, 19.99);
                  },
                  child: Text('Buy')),
              title: Text('5000 Krushin Coins'),
              subtitle: Text('\$19.99'),
              leading: Image.asset(
                'assets/images/coins_large.png',
                width: 32,
              ),
            ),
          ),
          )
       
         
        ]
      ],
    );
  }

  Widget getTransactionTab() {
      return BlocBuilder(
    cubit: transactionsBloc,
    builder: (BuildContext context, TransactionsState state) {
      
    return Column(
      children: <Widget>[
        Divider(),
        state is TransactionsLoading ? 
        Container(
                  height: wp(30), child:  Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        )) :
 state is TransactionsLoadingError ? Text("failure") :
 state is TransactionsLoaded ?
        ListView.separated(
          shrinkWrap: true,
          itemCount: state.transactionsList.length,
          itemBuilder: (context, i) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Card(
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/coins_small.png',
                    width: 32,
                  ),
                  title: Text('Krushin Coins'),
                  trailing: Text(
                    '\$ ${state.transactionsList[i].toString()}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ): Container()
      ],
    );
      
 
}
      
    
  );

  }
}
