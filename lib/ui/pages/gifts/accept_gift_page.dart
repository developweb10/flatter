import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/gift_recieved_bloc/gift_recieved_bloc_bloc.dart';
import '../../../model/recieved_gifts.dart';
import '../../dialogs/accept_gift_dialog.dart';
import '../../../utils/T.dart';
import '../../../utils/progress_bar.dart';
import '../../../model/gift_model_krushin.dart';
import '../../../repositories/gift_repository.dart';
import '../../../repositories/payment_page_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';


class AcceptGiftPage extends StatefulWidget {
  bool fromChat;
  String krushName;
  String orderId;
List<GiftModelKrushin> products;
String status;
AcceptGiftPage({this.fromChat, this.krushName, this.products, this.orderId, this.status});

  @override
  State<StatefulWidget> createState() {
    return _AcceptGiftPageState();
  }
}

class _AcceptGiftPageState extends State<AcceptGiftPage> {
  Function wp;
  List<GiftModelKrushin> products = [];
  bool new_card = true;
  int groupValue = -1;
  String stripeId;
  String token;
  bool _loadingCards = false;
  bool _loading = true;
  double price = 10.00;
String krushName = "";
String orderId = "";
  PaymentPageRepository paymentPageRepository = PaymentPageRepository();
    GiftRepository giftRepository = GiftRepository();
String status;


rejectGift() async {   
  ProgressBar.client.showProgressBar(context);
    await giftRepository
        .rejectGift(
            widget.orderId.toString())
        .then(
      (v) {
          ProgressBar.client.dismissProgressBar();
        if (v.status) {
          context.bloc<GiftRecievedBloc>().add(GiftsListChanged());
          Navigator.of(context).pop();
          
        }
          T.message(v.message);
      },
    );
}

getGift() async {
  
  if(widget.fromChat == true){
    setState(() {
      _loading = true;
    });
      RecievedGifts recievedGift = await giftRepository.getReceivedGift(  widget.orderId.toString(), );
      if(recievedGift.status){
        setState(() {
          products = recievedGift.data.giftRecieved[0].products;
          krushName = widget.krushName;
          orderId = widget.orderId;
          status = recievedGift.data.giftRecieved[0].hasAccepted;
        });
      }
      
      setState(() {
      _loading = false;
    });
  }else{
    setState(() {
         _loading = false;
      products = widget.products;
      krushName = widget.krushName;
      orderId = widget.orderId;
      status = widget.status;
    });
  }
}

  @override
  void initState() {
    getGift();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
backgroundColor: Colors.redAccent,
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
                                krushName + " sent you",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .apply(color: Colors.redAccent),
                              ),
                              Text(
                                "a gift",
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

                  Flexible(child: products.length == 1 ? Center(child: Container(height: 200,
                  
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

               
                
                 
               
          ],)
         
        ]
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height*0.150,
                    decoration: BoxDecoration(
                   color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
        child: Center(child: _loading ?  Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ) : 

        status == 'pending'?
   Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.red)   
                                                                                ),
                                                                        color: Colors
                                                                            .white,
                                                                        textColor:
                                                                            Colors.red,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () async {
                                                                  rejectGift();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Reject Gift",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                   SizedBox( width: 30,),
                                                                      FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                               side: BorderSide(color: Colors.white)     
                                                                                ),
                                                                        color: Colors
                                                                            .redAccent,
                                                                        textColor:
                                                                            Colors.white,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () async {
                                                                          bool result = await showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) =>
                AcceptGiftDaialog(orderId)));    
                if(result){
                    context.bloc<GiftRecievedBloc>().add(GiftsListChanged());
                    
                    Navigator.of(context).pop();
                }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Accept Gift",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                          ),
                                                                        ),
                                                                      )
                                        ],
                                      ): status == 'Shipped.' ? Text("Your gift is shipped."): Text("You already $status the gift."),),
        
      
      )  
      );
        
}
}