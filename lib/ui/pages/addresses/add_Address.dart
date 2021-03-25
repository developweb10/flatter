
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/bloc/billing_address_bloc/billing_address_bloc_bloc.dart';
import 'package:krushapp/bloc/shipping_address_bloc/shipping_address_bloc_bloc.dart';
import 'package:krushapp/model/get_user_response.dart';
import 'package:krushapp/repositories/address_repository.dart';
import 'package:krushapp/utils/T.dart';

import 'dart:io' as file;

import 'package:krushapp/utils/shapes.dart';

class AddAddress extends StatefulWidget {
  ShippingAddressBlocBloc shippingAddressBlocBloc;
  BillingAddressBlocBloc billingAddressBlocBloc;
  String type;
   AddAddress(this.type,{this.shippingAddressBlocBloc, this.billingAddressBlocBloc} );


  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress>
    with TickerProviderStateMixin {
  Function wp;
  DateTime dob_dateTime;
  final TextEditingController addressLineController = new TextEditingController();
  final TextEditingController countryController = new TextEditingController();
  final TextEditingController stateController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  final TextEditingController zipcodeController = new TextEditingController();

  Country selectedCountry = Country.US;
  AddressRepository addressRepository = AddressRepository();

    UserResponse userResponse;

  Future<void> addAddress(String adressLine, String city, String state, String country, String zipcode) async {
 if (await ApiClient.apiClient.addAddress(widget.type, adressLine,   city,   state,   country,   zipcode)) {
      if(widget.type == "Billing"){
 widget.billingAddressBlocBloc.add(LoadBillingAddress());
      }else{
 widget.shippingAddressBlocBloc.add(LoadShippingAddress());
      }
      
      
        Navigator.of(context).pop();
      }
  }
  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
            child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: Row(
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
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add ${widget.type} Address",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .apply(color: Colors.white),
                          )
                        ],
                      ))
                    ],
                  )),
            ),
          )),
      body: Container(
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
        child: Card(
          shape: cardShapeFromTop(20),
          color: Theme.of(context).backgroundColor,
          elevation: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // width: config.App(context).appWidth(88),

            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              // shrinkWrap: true,
              children: <Widget>[
    
        Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: addressLineController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Addresss Line", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      // height: 50,
                    ),
                  ],
                ),

                                SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: cityController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "City", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      // height: 50,
                    ),
                  ],
                ),

                                SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: stateController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "State", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      // height: 50,
                    ),
                  ],
                ),

                                SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.number,
                                        textCapitalization: TextCapitalization.words,
                                        controller: zipcodeController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Zipcode", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      // height: 50,
                    ),
                  ],
                ),
                   SizedBox(height: 15),

      Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(5),
                      child: _buildCountryCodePicker(),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      // height: 50,
                    ),
                  ],
                ),


  
                 SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  RaisedButton(
        onPressed: (){
          if(addressLineController.text.isEmpty|| cityController.text.isEmpty|| stateController.text.isEmpty|| selectedCountry == null || zipcodeController.text.isEmpty){
            T.message("Please fill all fields.");
          }else{
         addAddress(addressLineController.text, cityController.text, stateController.text, selectedCountry.name, zipcodeController.text);

          }
        },
        padding: EdgeInsets.symmetric(horizontal: 66, vertical: 14),
        color: Theme.of(context).accentColor,
        
        shape: StadiumBorder(),
        child: Text("Add Address",style: TextStyle(color:Colors.white ),),
      ),
                ],)

                    
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildCountryCodePicker() {
    return  CountryPicker(
          dense: false,
          showFlag: true,  //displays flag, true by default
          showDialingCode: false, //displays dialing code, false by default
          showName: true, //displays country name, true by default
          showCurrency: false, //eg. 'British pound'
          showCurrencyISO: true, //eg. 'GBP'
          onChanged: (Country country) {
            setState(() {
             selectedCountry = country;
             FocusScope.of(context).requestFocus(new FocusNode());
   
            });
             
          },
          selectedCountry: selectedCountry,
        );
    
  }
}
