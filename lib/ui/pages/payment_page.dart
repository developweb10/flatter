import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/bloc/cards_bloc/cards_bloc_bloc.dart';
import 'package:krushapp/bloc/krushin_coins_bloc/krushin_coins_bloc.dart';
import 'package:krushapp/utils/Constants.dart';

import '../../model/card_model.dart';
import '../../repositories/payment_page_repository.dart';

import '../../utils/T.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import 'package:stripe_payment/stripe_payment.dart';

class PaymentPage extends StatefulWidget {
  double dollars;
  int coins;
  KrushinCoinsBloc krushinCoinsBloc;
  CardsBlocBloc cardsBlocBloc;
  List<CardsModel> cardsList;
  Function selectCardIndex;
  int selectedIndex;
  PaymentPage({this.dollars, this.coins, this.krushinCoinsBloc, this.cardsBlocBloc, this.cardsList, this.selectCardIndex, this.selectedIndex});
  @override
  State<StatefulWidget> createState() {
    return _PaymentPageState();
  }
}

class _PaymentPageState extends State<PaymentPage> {
  Function wp;


  bool new_card = true;
  int groupValue = -1;
  String stripeId;
  
  bool _loadingCards = false;
   List<CardsModel> cardsList;

  PaymentPageRepository paymentPageRepository = PaymentPageRepository();





  void setError(dynamic error) {
  }

  void addCard(String stripeId, ) {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) async {
      if (await ApiClient.apiClient.attachPaymentMethos(
           stripeId, paymentMethod.id)) {
       widget.cardsBlocBloc.add(LoadCards());
      }
    }).catchError(setError);
  }



  @override
  void initState() {
    // TODO: implement initState
    // getCards();
    cardsList = widget.cardsList;
    StripePayment.setOptions(
        StripeOptions(publishableKey: Constants.production? Constants.stripePublishableKey_live: Constants.stripePublishableKey_test ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // here the desired height
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFfe4a49),
                    Color(0xFFfe4a49),
                    Color(0xFFff6060),
                    Color(0xFFff6060),
                  ]),
            ),
            child:  Center(
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: MediaQuery.of(context).size.height * 0.08,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  // color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      ),
                      
                      SizedBox(
                        width: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add Your",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .apply(color: Colors.white),
                              ),
                              Text(
                                "Payment Method",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(color: Colors.white),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            ),
          )),
      body: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Color(0xFFff6060),
                  Color(0xFFff6060),
                  Color(0xFFfe4a49),
                  Color(0xFFfe4a49),
                ],
              )),
              child:  BlocBuilder(
        cubit: widget.cardsBlocBloc,
        builder: (BuildContext context, CardsBlocState state) {

          if(state is CardsLoaded){
            cardsList = state.cardsList;
          }
          return Container(
              // color: Colors.white,
                height: double.infinity,
              child:  state is CardsLoading
                        ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
                        : state is CardsError
                            ?  Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                 SizedBox(
                                height: 20,
                              ),
                              Text('Error Fetching Cards'),
                              SizedBox(
                                height: 8,
                              ),
                              RaisedButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                             widget.cardsBlocBloc.add(LoadCards());
                                  })
                            ],
                          ),
                        )
                            : state is CardsLoaded || state is IndexSelected?  
               Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),

                      InkWell(
                        onTap: () async {
                          addCard(await UserSettingsManager.getStripeId());
                        },
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.add_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Add New Card",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .apply(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Divider(),
                      ListView.separated(
                              shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(), 
                              itemCount: cardsList == null ? 0 : cardsList.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () {
                                    // widget.cardsBlocBloc.add(SelectCard(index:i));
                                    setState(() {
                                      widget.selectedIndex = i;
                                    });

                                    widget.selectCardIndex(i);
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Stack(
                                            children: [
                                              widget.selectedIndex == i
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text("selected"),
                                                          Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green)
                                                        ],
                                                      ))
                                                  : Container(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Card Number',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .apply(
                                                            color: Colors.grey),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "xxxx xxxx xxxx " +
                                                          cardsList[i].last4,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline3),
                                                  SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Expiry Date',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                              cardsList[i]
                                                                      .exp_month +
                                                                  "/" +
                                                                  cardsList[i]
                                                                      .exp_month,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                        ],
                                                      ),
                                                      SizedBox(width: 30),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'CVV',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text("xxx",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ))),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            ),
                      Divider(),
                
                    ],
                  ),
                )
              : Container(),
    );
  
})));
}}