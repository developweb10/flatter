import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/app/theme.dart';
import 'package:krushapp/repositories/get_avatars_repository.dart';
import 'package:krushapp/repositories/number_format_repository.dart';
import 'package:krushapp/ui/pages/contacts_page.dart';
import 'package:krushapp/utils/T.dart';
import 'package:krushapp/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../repositories/get_avatars_repository.dart' as getAvatarRepository;
import 'krush_chat_page.dart';
import 'reveal_info_page.dart';

class KrushPhonePage extends StatefulWidget {
  bool skip;
  KrushPhonePage(this.skip);

  @override
  _KrushPageState createState() => _KrushPageState();
}

class _KrushPageState extends State<KrushPhonePage> {
  Function wp;
  static String selectedCountryCode = "+1";
  TextEditingController krushNumberController = new TextEditingController();
  NumberFormatRepository numberFormatRepository = NumberFormatRepository();
    // GetAvatarRepository getAvatarRepository = GetAvatarRepository();

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
  
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: backgroundDecoration,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SvgPicture.asset(
                    'assets/svg/login_bg.svg',
                    fit: BoxFit.cover,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                SafeArea(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 16),
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: Card(
                          color: Color(0xffF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      // margin: EdgeInsets.only(top: 20),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Center(
                                              child: Image.asset(
                                                  "assets/images/krush_number_top_background.png",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                  "assets/images/add_krush_girl.png",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20),
                                              Image.asset(
                                                  "assets/images/add_krush_boy.png",
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.20)
                                            ],
                                          )
                                        ],
                                      )),
                                  Flexible(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                     
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    // padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        _buildCountryCodePicker(),
                                                        Expanded(
                                                          child: TextField(
                                                            onChanged: (value){
                                                               String formattedNumber = numberFormatRepository.changeNumber(value);
                                                               if(formattedNumber.length == 10){
                                                                 FocusScope.of(context).requestFocus(new FocusNode());
                                                               }
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            controller:
                                                                krushNumberController,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            decoration:
                                                                InputDecoration(
                                                              // hintText: "Enter Your Phone Number",
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              labelText:
                                                                  "Krush's phone number",
                                                              // suffixIcon:
                                                              //     IconButton(
                                                              //         icon:
                                                              //             Icon(
                                                              //           Icons
                                                              //               .contacts,
                                                              //           color: Colors
                                                              //               .grey,
                                                              //         ),
                                                              //         onPressed:
                                                              //             () {
                                                              //           selectContacts();
                                                              //           // selectBlockedContacts();
                                                              //         }),
                                                            ),
                                                            //controller: email,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ]),

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            // height: 50,
                                          ),

                                           SizedBox(
                                                  width: 5
                                                ),

                                                InkWell(
                                                  onTap:(){
selectContacts();
                                                  },

                                                  child:  Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                                                  // padding: EdgeInsets.all(5),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                    children:[
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                          2
                                                        ),
                                                        child:Column(
                                                        children:[
                                                          Text('Add from', style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors.white
                                                                  ),),

                                                          Text('contacts', style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors.white
                                                                  ),)
                                                        ]
                                                      ),
                                                      ),
                                                      
                                                      Image.asset(
                                                        "assets/images/contacts_icon.png",
                                                        height: 35)

                                                    ]
                                                  )     ,
                                                       
   
                                      
                                                        
                                                      ]),

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.redAccent,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor)),
                                                  // height: 50,
                                                ),
                                                )
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  AutoSizeText(
                                                    "Connect anonymously with your krush",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                    maxLines: 1,
                                                  ),
                                                  AutoSizeText(
                                                      "Your krush will never know who you are,",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 15),
                                                      maxLines: 1),
                                                  AutoSizeText(
                                                      "unless you reveal yourself",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 15),
                                                      maxLines: 1),
                                                ]),

                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Color(0xffFF5252),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            // height: 50,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                                ],
                              )
                            ],
                          )),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: Offset(0, 20),
                              blurRadius: 40)
                        ]),
                        width: 246,
                        height: 46,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () async {
                           String formattedNumber = numberFormatRepository.changeNumber(krushNumberController.text);
                            if(formattedNumber.length < 10){
                           T.message("Please enter valid Mobile Number.");
                        } else {
                          formattedNumber = formattedNumber.substring(formattedNumber.length-10);
                          String userPhoneNumber = await UserSettingsManager.getUserPhone();
                          if(userPhoneNumber == selectedCountryCode + formattedNumber){
                            T.message("You can't send a krush request to yourself.");
                          }else{
                            Navigator.pushNamed(context, '/KrushChatPage', arguments: selectedCountryCode + formattedNumber);
                          }
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),

                  ],
                )),
                SafeArea(
                    child: Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 28.0,
                                height: 28.0,
                                decoration: new BoxDecoration(
                                  color: Theme.of(context).accentColor,
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
                            )
                          ],
                        )))
              ],
            )));
  }



  Widget _buildCountryCodePicker() {
    return CountryCodePicker(
      initialSelection: 'US',
      favorite: ['+1', 'US'],
      showCountryOnly: true,
      showFlag: true,
      showOnlyCountryWhenClosed: false,
      onChanged: (value) {
        setState(() {
          selectedCountryCode = value.toString();
        });
      },
    );
  }

  Future selectContacts() async {
    if (await Permission.contacts.request().isGranted) {
      var contact = await Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => ContactsPage()));
      if (contact != null) {
        krushNumberController.text = contact;


      }
    }
  }


}
