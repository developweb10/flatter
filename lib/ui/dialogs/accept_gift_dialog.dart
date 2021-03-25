import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/bloc/shipping_address_bloc/shipping_address_bloc_bloc.dart';
import 'package:krushapp/repositories/gift_repository.dart';
import '../pages/addresses/shippingAddressPage.dart';
import '../../model/addressModel.dart';
import '../../utils/T.dart';

class AcceptGiftDaialog extends StatefulWidget {

  String orderId;

  AcceptGiftDaialog(this.orderId);
  @override
  _AcceptGiftDaialogState createState() => _AcceptGiftDaialogState();
}

class _AcceptGiftDaialogState extends State<AcceptGiftDaialog> {
  
  List<AddressModel> addressList;
  int selectedIndex = 0;
ShippingAddressBlocBloc shippingAddressBlocBloc = ShippingAddressBlocBloc();
  GiftRepository giftRepository = GiftRepository();
  bool _loading = false;
selectIndex(int index){
  setState(() {
    selectedIndex = index;
  });
}

acceptGift() async {
  setState(() {
    _loading = true;
  });
  dynamic result = await giftRepository.acceptGift( widget.orderId, addressList[selectedIndex].id.toString());
   setState(() {
    _loading = true;
  });
  if(result == true){
    T.message("You accepted the gift.");

    Navigator.of(context).pop(true);
  }else{
    T.message(result);
  }

}
@override
  void initState() {
    // TODO: implement initState
      shippingAddressBlocBloc.add(LoadShippingAddress());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return    Container(
          height: MediaQuery.of(context).size.height*0.31,
          width: MediaQuery.of(context).size.width,
          padding: 
          EdgeInsets.all(20),
          child: BlocBuilder(
        cubit: shippingAddressBlocBloc,
        builder: (BuildContext context, ShippingAddressBlocState state) {

          if(state is ShippingAddressLoaded){
            addressList = state.addressList;
            if(addressList.length > 0){
              // widget.addressBlocBloc.add(SelectShippingAddress(index:0));
            }
          }else if(state is ShippingIndexSelected){
            // selectedIndex = state.index;
          }
          return Container(
              child: state is ShippingAddressLoading
                        ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
                        : state is ShippingAddressError
                            ?  Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                 SizedBox(
                                height: 20,
                              ),
                              Text('Error Fetching Address'),
                              SizedBox(
                                height: 8,
                              ),
                              RaisedButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                  shippingAddressBlocBloc.add(LoadShippingAddress());
                                  })
                            ],
                          ),
                        )
                            : state is ShippingAddressLoaded || state is ShippingIndexSelected ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
                     Text("Please add your shipping address to receive your gift, and don't worry your shipping address will remain anonymous.", style: TextStyle(fontSize: 14 ), textAlign: TextAlign.center,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
             
                Text("Shipping address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700 ),),
                InkWell(
                  onTap: () {
              
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ShippingAddressPage(addressList: addressList, shippingAddressBlocBloc: shippingAddressBlocBloc, selectIndex: selectIndex, selectedIndex: selectedIndex, )),
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

            addressList.length > 0 && selectedIndex!=null ?    Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: AutoSizeText(addressList[selectedIndex].addressLine+", "+addressList[selectedIndex].city+", "+addressList[selectedIndex].state+", "+addressList[selectedIndex].country, maxLines: 4, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700 , color: Colors.black54),),

              ),

                Row(children: [
                   Text("selected", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 ),),
                   SizedBox(
                     width: 5,
                   ),
                 Icon(Icons.check_circle, color: Color(0xff31D8AC),)
                   
                ],)

              ],): Container(),
Container(
                 width: 220,
                 child:  FloatingActionButton.extended(
            hoverElevation: 8,
            elevation: 0,
            label: Text(
              _loading ? 'Loading...' : 'Confirm and accept gift!',
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
              if(addressList.length > 0 && selectedIndex!=null){
                acceptGift();
              }else{
                T.message("Please select an address");
              }

      
            },
            backgroundColor: Theme.of(context).primaryColor,
          ),
               )
                  
            ],
          ): Container(),);})
        )
   ;
  }
}
