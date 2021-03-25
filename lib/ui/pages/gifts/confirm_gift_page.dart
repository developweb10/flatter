import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krushapp/app/api.dart';
import '../../../bloc/billing_address_bloc/billing_address_bloc_bloc.dart';
import '../../../model/addressModel.dart';
import '../../../model/sent_gifts.dart';
import '../addresses/billingAddressPage.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/cards_bloc/cards_bloc_bloc.dart';
import '../../../bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import '../../../model/gift_model_krushin.dart';
import '../../../repositories/gift_repository.dart';
import '../payment_page.dart';
import '../../../utils/T.dart';
import '../../../utils/shapes.dart';
import '../../../model/card_model.dart';
import '../../../repositories/payment_page_repository.dart';


import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'gift_sent_confirm.dart';

class ConfirmGiftPage extends StatefulWidget {
  bool fromChat;
  String krushName;
  String orderId;
List<GiftModelKrushin> products;
String status;
ConfirmGiftPage({this.status,this.fromChat, this.krushName, this.products, this.orderId});

  @override
  State<StatefulWidget> createState() {
    return _ConfirmGiftPageState();
  }
}

class _ConfirmGiftPageState extends State<ConfirmGiftPage> {
  Function wp;

  int selectIndex;
  bool new_card = true;
  int groupValue = -1;
  String stripeId;
  String token;
  bool _loadingCards = false;
  List<CardsModel> cardsList = [];
  int selectedIndex_cards = 0;
  int selectedIndex_address = 0;
  double price = 10.00;
  bool _loading = false;
BillingAddressBlocBloc billingAddressBlocBloc = BillingAddressBlocBloc();
  PaymentPageRepository paymentPageRepository = PaymentPageRepository();
    GiftRepository giftRepository = GiftRepository();
CardsBlocBloc cardsBlocBloc = CardsBlocBloc();
  List<AddressModel> addressList = [];
    List<GiftModelKrushin> products = [];
String krushName = "";
String orderId = "";
String status;
bool loading_gift = false;


calculatePrice(){
  if(products[0].product != null){
  for(int i=0; i<products.length; i++){
    price = price +  double.parse(products[i].product.price).round();
  }
  }


  setState(() {
    price = price;
  });
}

selectAddressIndex(int index){
  setState(() {
    selectedIndex_address = index;
  });
}

selectCardIndex(int index){
  setState(() {
    selectedIndex_cards = index;
  });
}


  makePayment(String paymentMethodId, String billingAddressId) async {
    setState(() {
      _loading = true;
    });
  if (await ApiClient.apiClient.makePayment(
          price, paymentMethodId)) {
   await giftRepository.confirmPayment( orderId, billingAddressId).then((value){

     if(value.status){

      setState(() {
      _loading = false;
    });
       T.message("Your gift will be delivered soon!");
     
  context.bloc<GiftSentBloc>().add(GiftSentListChanged());
      
         
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => GiftSentConfirm(krushName)),
  );
     }else{
       setState(() {
      _loading = false;
    });
       T.message(value.message);
     }


   });
      }else{
        setState(() {
      _loading = false;
    });
      };
       
  }

  getGift() async {
  
  if(widget.fromChat == true){
    setState(() {
      loading_gift = true;
    });
      SentGifts sentGifts = await giftRepository.getSentGift(  orderId.toString(), );
      if(sentGifts.status){
        setState(() {
          products = sentGifts.data.giftSent[0].products;
          krushName =  widget.krushName;
          orderId = widget.orderId;
          status = sentGifts.data.giftSent[0].hasAccepted;
        });
      }
      
      setState(() {
      loading_gift = false;
    });
  }else{
    setState(() {
      loading_gift = false;
      products = widget.products;
      krushName =  widget.krushName;
      orderId =  widget.orderId;
      status =  widget.status;
    });
  }

  calculatePrice();
}

  @override
  void initState() {
     getGift();
  
 
    StripePayment.setOptions(
        StripeOptions(publishableKey: "pk_test_rKarLZNQ7vgrqbQZuZ4rujXp"));
    cardsBlocBloc.add(LoadCards());
    billingAddressBlocBloc.add(LoadBillingAddress());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(

      body:
      Stack(
        children:[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SvgPicture.asset(
              'assets/svg/login_bg.svg',
              fit: BoxFit.cover,
            ),
            color: Theme.of(context).primaryColor,
          ),

          Column(
            
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
                    children: [
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
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      ),
                     
                      SizedBox(
                        width: 20,
                      ),

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
                                "Sending Gift to",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .apply(color: Colors.redAccent),
                              ),
                              Text(
                                krushName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .apply(color: Colors.redAccent),
                              )
                            ],
                          )
                      )
                     
                    ],
                  ),

                  
                    ],)
                  ),

                Flexible(child:  products.length == 1 ? Center(child: Container(height: 200,
                  
                  width: 200,
                  child: Card(
      shape: RoundedRectangleBorder(
    // side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
      child: Padding(padding: 
        EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            Flexible(child: 
            Stack(
                                            children: [
                                             CachedNetworkImage(imageUrl: products[0].product.imageLarge,
                                                                    imageBuilder: (context, imageProvider) => Container(
 
    height: 200,                                                                    
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider, fit: BoxFit.cover),
    ),

    
  )),

  
  ])
            ),

          Text(products[0].product.name),
          ],
        ) )
    ) ,
                  ),)  : Center(child: GridView.builder(
  itemCount: products.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2),
  itemBuilder: (BuildContext context, int index) {
    return new Card(
      shape: RoundedRectangleBorder(
    // side: BorderSide(color: Colors.white70, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
      child:Padding(padding: 
        EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            Flexible(child: 
            Stack(
                                            children: [
                                             CachedNetworkImage(imageUrl: products[index].product.imageLarge,
                                                                    imageBuilder: (context, imageProvider) => Container(
 
    height: 200,                                                                    
    decoration: BoxDecoration(
      image: DecorationImage(
        image: imageProvider, fit: BoxFit.cover),
    ),

    
  )),

  
  ])
            ),

            Text(products[index].product.name),
          ],
        ) )
    );
  },
),)  
                  ),

                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [

                       Card(
        shape: cardShapeFromTop(30),
        color: Colors.white38,
        child: Container(
        height: MediaQuery.of(context).size.height*0.36,
            width: MediaQuery.of(context).size.width*0.85,

        )
      ),

   Card(
        shape: cardShapeFromTop(30),
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height*0.32,
          width: MediaQuery.of(context).size.width,
          padding: 
          EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: loading_gift ? Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ):

          status != 'accepted' ? Center(child: Text("Your gift is $status.")
          ,) :
           Column(
            // shrinkWrap: true,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
BlocBuilder(
        cubit: cardsBlocBloc,
        builder: (BuildContext context, CardsBlocState state) {

          if(state is CardsLoaded){
            cardsList = state.cardsList;
            
          }else if(state is IndexSelected){
            // selectedIndex = state.index;
          }
          return Container(
              color: Colors.white,
              child: state is CardsLoading
                        ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
                        : state is CardsError
                            ?  Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
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
                                  cardsBlocBloc.add(LoadCards());
                                  })
                            ],
                          ),
                        )
                            : state is CardsLoaded || state is IndexSelected ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
                      Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
                Text("Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 ),),
                InkWell(
                  onTap: () {
                  },
                  child: Row(children: [
                   Text(price==null ? "":"\$${price.toString()}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
    
                   
                ],),
                )
                

              ],),
              SizedBox(
height: 5,
),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
                Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 ),),
                InkWell(
                  onTap: () {
                    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PaymentPage(cardsBlocBloc: cardsBlocBloc, cardsList: cardsList, selectCardIndex: selectCardIndex, selectedIndex: selectedIndex_cards,),
                    ));

                  },
                  child: Row(children: [
                   Text("Add/Change card", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
                   SizedBox(
                     width: 5,
                   ),
                 Icon(Icons.add_circle, color: Color(0xff31D8AC),)
                   
                ],),
                )
                

              ],),
SizedBox(
height: 5,
),
            cardsList.length > 0 && selectedIndex_cards!=null ?  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
                Text("xxxx xxxx xxxx " + cardsList[selectedIndex_cards].last4 , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 ),),

                Row(children: [
                   Text("selected", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
                   SizedBox(
                     width: 5,
                   ),
                 Icon(Icons.check_circle, color: Color(0xff31D8AC),)
                   
                ],)

              ],): Container(),

            ],
          ): Container(),);}),


          BlocBuilder(
        cubit: billingAddressBlocBloc,
        builder: (BuildContext context, BillingAddressBlocState state) {

          if(state is BillingAddressLoaded){
            addressList = state.addressList;
            
          }
          return Container(
              child:

                            
                            
                             Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
                   
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              
                Text("Billing address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 ),),
                InkWell(
                  onTap: () {
              
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BillingAddressPage(addressList: addressList, billingAddressBlocBloc: billingAddressBlocBloc, selectIndex: selectAddressIndex, selectedIndex: selectedIndex_address,)),
  );
                  },
                  child: Row(children: [
                   Text("Add/Change address", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
                   SizedBox(
                     width: 5,
                   ),
                 Icon(Icons.add_circle, color: Color(0xff31D8AC),)
                   
                ],),
                )
                

              ],),
SizedBox(
height: 5,
),
            addressList != null && addressList.length > 0 && selectedIndex_address!=null ?    Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                // width: MediaQuery.of(context).size.width*0.6,
                child: AutoSizeText(addressList[selectedIndex_address].addressLine+", "+addressList[selectedIndex_address].city+", "+addressList[selectedIndex_address].state+", "+addressList[selectedIndex_address].country, maxLines: 4, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 , color: Colors.black54),),

              ),

                // Row(children: [
                //    Text("selected", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
                //    SizedBox(
                //      width: 5,
                //    ),
                //  Icon(Icons.check_circle, color: Color(0xff31D8AC),)
                   
                // ],)

              ],): Container(),
SizedBox(
height: 5,
),
               Container(
                 width: 220,
                 child:FloatingActionButton.extended(
            hoverElevation: 8,
            elevation: 0,
            
            label: Text(
              _loading ? 'Loading...':'Confirm and accept gift!',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            onPressed: () async {
              if(addressList.length > 0 && selectedIndex_address!=null){
                makePayment(cardsList[selectedIndex_cards].paymentMethodId, addressList[selectedIndex_address].id.toString());
              }else{
                T.message("Please select an address");
              }

      
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
               )     
            ],
          ),);})
            ],
          ) 
        )
      )
                  ],
                )
                
                 
               
          ],)
         
        ]
      ),
      
      );
        
}
}