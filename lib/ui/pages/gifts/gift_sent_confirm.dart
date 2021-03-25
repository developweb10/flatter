import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krushapp/bloc/cards_bloc/cards_bloc_bloc.dart';
import 'package:krushapp/utils/shapes.dart';

import '../../../model/card_model.dart';
import '../../../repositories/payment_page_repository.dart';


import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import 'package:stripe_payment/stripe_payment.dart';

class GiftSentConfirm extends StatefulWidget {
String krushName;

GiftSentConfirm(this.krushName);
  @override
  State<StatefulWidget> createState() {
    return _GiftSentConfirmState();
  }
}

class _GiftSentConfirmState extends State<GiftSentConfirm> {
  Function wp;

  int selectIndex;
  bool new_card = true;
  int groupValue = -1;
  String stripeId;
  String token;
  bool _loadingCards = false;
  List<CardsModel> cardsList;
  int selectedIndex;
  double price = 110.00;

  PaymentPageRepository paymentPageRepository = PaymentPageRepository();
CardsBlocBloc cardsBlocBloc = CardsBlocBloc();


  @override
  void initState() {
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_rKarLZNQ7vgrqbQZuZ4rujXp"));
    cardsBlocBloc.add(LoadCards());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
            
            children: [

              Container(
                  margin: EdgeInsets.only(top: 80),
                  height: MediaQuery.of(context).size.height * 0.11,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                     
                    

                      Container(
                        
                         decoration:
                                                            new BoxDecoration(
                                                   color: Colors.white,
                                                   borderRadius: BorderRadius.all(Radius.circular(10))
                                                          // shape:
                                                          //     BoxShape.circle,
                                                  
                                                        ),
                        padding: EdgeInsets.all(10),
                        child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Gift Sent to",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .apply(color: Colors.redAccent),
                              ),
                              Text(
                               widget.krushName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(color: Colors.redAccent),
                              )
                            ],
                          )
                      ),

                      InkWell(
                        onTap:(){
                          Navigator.of(context).pop();
                        },

                        child:  Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                            size: 35,
                          ),
                        ),
                      ),
                      ),
                     
                    ],
                  ),

                  
                    ],)
                  ),

                  Flexible(child:     Center(
                                              child: Image.asset(
                                                  "assets/images/gift_sent.png",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25),)
                  ,),

                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [

                       Card(
        shape: cardShapeFromTop(30),
        color: Color(0xffFF5252).withOpacity(0.2),
        child: Container(
        height: MediaQuery.of(context).size.height*0.30,
            width: MediaQuery.of(context).size.width*0.85,
    
         
          child: 
        Align(alignment: Alignment.topCenter,
        child:   Padding(padding: EdgeInsets.only(top: 20),
        child: Icon(Icons.check_circle, color: Color(0xff31D8AC), size: 50,)  ,
        
        )
        )
         
        
        )
      ),

   Card(
        shape: cardShapeFromTop(30),
        color: Colors.redAccent,
        child: Container(
          height: MediaQuery.of(context).size.height*0.18,
          width: MediaQuery.of(context).size.width,
          padding: 
          EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Container(
          height: MediaQuery.of(context).size.height*0.05,
          width: MediaQuery.of(context).size.width*0.5, 
    
          child:       FloatingActionButton.extended(
            hoverElevation: 8,
            elevation: 2,
            label: Text(
              'Sent',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            onPressed: () async {
  
            },
            backgroundColor: Colors.white,
            heroTag: "btn1",
          ),)
        )
      )
                  ],
                )
                
                 
               
          ],)
      
      );
        
}
}