
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import '../../model/get_user_response.dart';
import '../../bloc/account_page_bloc/account_page_bloc.dart';
import '../../repositories/date_of_birth_repository.dart' show DateOfBirthRepository;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' as file;

import 'package:krushapp/utils/shapes.dart';

class EditAccountDetails extends StatefulWidget {

  Map args;
  EditAccountDetails(this.args);


  @override
  _EditAccountDetailsState createState() => _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails>
    with TickerProviderStateMixin {
  Function wp;
  DateTime dob_dateTime;


  final TextEditingController emaiController = new TextEditingController();
  final TextEditingController displayNameController = new TextEditingController();
  final TextEditingController countryController = new TextEditingController();
  final TextEditingController stateController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  final TextEditingController zipcodeController = new TextEditingController();
   final TextEditingController dobController = new TextEditingController();

DateOfBirthRepository dateOfBirthRepository = DateOfBirthRepository();
  Country selectedCountry = Country.US;


    UserResponse userResponse;

autoCompleteData(UserResponse userResponse){
setState(() {
    displayNameController.text = userResponse.data.profile.displayName;
    emaiController.text = userResponse.data.user.email;
    countryController.text = userResponse.data.profile.country;
    stateController.text = userResponse.data.profile.state;
    cityController.text = userResponse.data.profile.city;
    zipcodeController.text = userResponse.data.profile.zipcode;
    dobController.text = dateOfBirthRepository.changeDOB(userResponse.data.profile.dateOfBirth);
dob_dateTime = userResponse.data.profile.dateOfBirth;
});
}
  @override
  void initState() {

    this.userResponse = widget.args['userResponse'];
    autoCompleteData(this.userResponse);

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
                            Icons.arrow_back_ios_outlined,
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
                            "Edit Details",
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
              shrinkWrap: true,
              children: <Widget>[
                // SizedBox(height: 15),
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
                            // Text(
                            //   "Your Name",
                            // ),
                            Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: displayNameController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Your Name", // and add this line
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

                InkWell(
                  onTap: () {
                 FocusScope.of(context).requestFocus(new FocusNode());
                                      showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now())
                      .then((date) {
                    setState(() {
                      dob_dateTime = date;
                      dobController.text = dateOfBirthRepository.changeDOB(date);
                    });
                  });
                  },
                  child: Row(
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
                            // Text(
                            //   "Date of birth",
                            // ),
                             Container(
                              // height: 30,
                              child: IgnorePointer(
                                child:  TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: dobController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Date of Birth", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                              )
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
                ),
                
                SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        textCapitalization: TextCapitalization.words,
                                        controller: emaiController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Your Email", // and add this line
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
     labelText: "Your City", // and add this line
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
     labelText: "Your State", // and add this line
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
     labelText: "Your Zipcode", // and add this line
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
          context.bloc<AccountPageBloc>().add(UpdateInfo(
            displayNameController.text, emaiController.text, dob_dateTime.toIso8601String(), selectedCountry.name,stateController.text, cityController.text, zipcodeController.text)
          );
          Navigator.of(context).pop();
        },
        padding: EdgeInsets.symmetric(horizontal: 66, vertical: 14),
        color: Theme.of(context).accentColor,
        
        shape: StadiumBorder(),
        child: Text("Update",style: TextStyle(color:Colors.white ),),
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
