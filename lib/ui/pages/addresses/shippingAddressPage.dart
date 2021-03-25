import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krushapp/bloc/shipping_address_bloc/shipping_address_bloc_bloc.dart';
import '../../../app/shared_prefrence.dart';
import '../../../model/addressModel.dart';
import '../../../repositories/address_repository.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import 'package:stripe_payment/stripe_payment.dart';

import 'add_Address.dart';

class ShippingAddressPage extends StatefulWidget {
  ShippingAddressBlocBloc shippingAddressBlocBloc;
  List<AddressModel> addressList;
  Function selectIndex;
  int selectedIndex;
  ShippingAddressPage({this.addressList,this.shippingAddressBlocBloc, this.selectIndex, this.selectedIndex});
  @override
  State<StatefulWidget> createState() {
    return _ShippingAddressPageState();
  }
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  Function wp;

  bool new_card = true;
  int groupValue = -1;
  String stripeId;
  String token;
  bool _loadingCards = false;
   List<AddressModel> addressList;

  AddressRepository addressRepository = AddressRepository();





  void setError(dynamic error) {
  }





  @override
  void initState() {
    // TODO: implement initState
    // getCards();
    addressList = widget.addressList;
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
                                "Shipping Address",
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
              // height: double.infinity,
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
        cubit: widget.shippingAddressBlocBloc,
        builder: (BuildContext context, ShippingAddressBlocState state) {
          if(state is ShippingAddressLoaded){
            addressList = state.addressList;
          }else if(state is ShippingIndexSelected){
            // selectedIndex = state.index;
          }
          return Container(
              // color: Colors.white,
              child:  state is ShippingAddressLoading
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
                              Text('Error Fetching Cards'),
                              SizedBox(
                                height: 8,
                              ),
                              RaisedButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                             widget.shippingAddressBlocBloc.add(LoadShippingAddress());
                                  })
                            ],
                          ),
                        )
                            : state is ShippingAddressLoaded || state is ShippingIndexSelected?  
            Container(

                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      SizedBox(height: 20),

                      InkWell(
                        onTap: () async {
                                                                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddAddress("Shipping", shippingAddressBlocBloc:widget.shippingAddressBlocBloc)),
  );
                        },
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.add_circle, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Add New Address",
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
                              itemCount: addressList == null ? 0 : addressList.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () {
                                    //  widget.addressBlocBloc.add(LoadShippingAddress());
                                    // widget.shippingAddressBlocBloc.add(SelectShippingAddress(index:i));
                                    setState(() {
                                      widget.selectedIndex = i;
                                    });
                                    widget.selectIndex(i);
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
                                                    'AddressLine',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .apply(
                                                            color: Colors.grey),
                                                  ),
                                                  SizedBox(height: 10),
                                                  AutoSizeText(
                                                      addressList[i].addressLine,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6.apply(fontWeightDelta: 5),

                                                      maxLines: 2,
                                                          
                                                      ),
                                                  SizedBox(height: 15),
                                                        
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      

                                                       Container(
                                                width: MediaQuery.of(context).size.width*0.35,
                                                child:Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          AutoSizeText(
                                                            'City',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 5),
                                                          AutoSizeText(
                                                              addressList[i].city,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                          SizedBox(height: 15),
                                                          AutoSizeText(
                                                            "Country",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 5),
                                                          AutoSizeText(
                                                              addressList[i].country,
                                                              maxLines: 1,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                               
                                                          
                                                        ],
                                                      ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.35,
                                                child:Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                                mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          AutoSizeText(
                                                            'State',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 5),
                                                          AutoSizeText(
                                                              addressList[i].state,
                                                              // overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                          SizedBox(height: 15),
                                                          AutoSizeText(
                                                            'Zipcode',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .apply(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          SizedBox(height: 5),
                                                          AutoSizeText(
                                                              addressList[i].zipcode,
                                                              maxLines: 1,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline4),
                                                         
                                                         
                                                        ],
                                                      ) ,
                                              )
                                                      
                                                    ],
                                                  ),

                                               
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