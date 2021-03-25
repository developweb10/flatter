import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import '../../app/shared_prefrence.dart';
import '../../app/theme.dart';
import '../../bloc/krush_add_bloc/krush_add_bloc.dart';
import 'package:krushapp/repositories/get_avatars_repository.dart';
import '../../repositories/number_format_repository.dart';
import 'package:krushapp/ui/dialogs/confirm_add_krush_dialog.dart';
import 'package:krushapp/ui/pages/contacts_page.dart';
import 'package:krushapp/utils/T.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:in_app_review/in_app_review.dart';

class AddKrushPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _AddCrushPageState();
  }
}

class _AddCrushPageState extends State<AddKrushPage> {
  TextEditingController krushNumberController = new TextEditingController();
  TextEditingController krushNameController = new TextEditingController();
  TextEditingController chatNameController = new TextEditingController();
  // TextEditingController firstLocationController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();
  Function wp;
  static String selectedCountryCode = "+1";
  int selectedAvatarIndex;
  int selectIndex;
  int coins_left;
  int free_requests;
  int radius = 9;
  KrushAddBloc krushAddBloc = KrushAddBloc();
  NumberFormatRepository numberFormatRepository = NumberFormatRepository();
final InAppReview inAppReview = InAppReview.instance;


  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdsRepository.getInterstitialAdUnitId(),
      listener: (MobileAdEvent event) {
      },
    );
  }
  getData() async {
    UserSettingsManager.getuserCoins().then((t) {
      setState(() {
        coins_left = t;
      });
    });

    UserSettingsManager.getFreesendRequestssAllowed().then((t) {
      setState(() {
        free_requests = t;
      });
    });

    createInterstitialAd()
          ..load()
          ..show();
//     if (await inAppReview.isAvailable()) {
//       inAppReview.openStoreListing();
//     inAppReview.requestReview();
// }else{
// }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: BlocConsumer(
            cubit: krushAddBloc,
            listener: (context, state) {
              
            },
            builder: (BuildContext context, KrushAddState state) {
              return Container(
                  //  height: double.infinity,

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
                        shrinkWrap: true,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: Card(
                                color: Color(0xffF2F2F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            // margin: EdgeInsets.only(top: 20),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.27,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                    child: Image.asset(
                                                        "assets/images/krush_number_top_background.png",
                                                        height: MediaQuery.of(
                                                                    context)
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
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.20),
                                                    Image.asset(
                                                        "assets/images/add_krush_boy.png",
                                                        height: MediaQuery.of(
                                                                    context)
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.60,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.095,
                                                  // padding: EdgeInsets.all(5),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          // color: Colors.black,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              _buildCountryCodePicker(),

                                                              Expanded(
                                                                child:
                                                                    TextField(
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
                                                                    //           Icons.contacts,
                                                                    //           color: Colors.grey,
                                                                    //         ),
                                                                    //         onPressed:
                                                                    //             () {
                                                                    //           selectContacts();
                                                                    //         }),
                                                                  ),
                                                                  //controller: email,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                       

                                      
                                                        
                                                      ]),

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
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
                                                      0.095,
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
                                                      0.8,
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Text(
                                                        //   "Enter your krush's real name", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                        // ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          //  height: 20,
                                                          child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .words,
                                                            controller:
                                                                krushNameController,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          5), //Change this value to custom as you like
                                                              isDense: true,
                                                              labelText:
                                                                  "Enter your krush's name", // and add this line
                                                            ),

                                                            //controller: email,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor)),
                                                  // height: 50,
                                                ),
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
                                                      0.8,
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  controller:
                                                                      commentController,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .sentences,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            vertical:
                                                                                5), //Change this value to custom as you like
                                                                    isDense:
                                                                        true,
                                                                    labelText:
                                                                        "Enter what you want to say to your krush", // and add this line
                                                                  ),
                                                                  //controller: email,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]),

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor)),
                                                  // height: 50,
                                                ),
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
                                                      0.8,
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Text(
                                                        //   "Enter your anonymous chat name", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                        // ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  controller:
                                                                      chatNameController,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            vertical:
                                                                                5), //Change this value to custom as you like
                                                                    isDense:
                                                                        true,
                                                                    labelText:
                                                                        "Enter your anonymous chat name", // and add this line
                                                                  ),
                                                                  //controller: email,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ]),

                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Theme.of(
                                                                  context)
                                                              .accentColor)),
                                                  // height: 50,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      //  Text(
                                                      //             "Chose your Anonymous Avatar", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                      //           ),

                                                      Container(
                                                        height: wp(20),
                                                        child: ListView.builder(
                                                          // padding: EdgeInsets.only(top: 2),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              GetAvatarRepository
                                                                  .avatarURLs
                                                                  .length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectedAvatarIndex =
                                                                      index;
                                                                  //  radius = 11;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(wp(
                                                                            1)),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    AnimatedContainer(
                                                                      duration: Duration(
                                                                          seconds:
                                                                              1),
                                                                      child: CircleAvatar(
                                                                          backgroundColor: Colors.black54,
                                                                          radius: selectedAvatarIndex == index ? wp(9) : wp(8),
                                                                          child: CachedNetworkImage(
                                                                              imageUrl: GetAvatarRepository.avatarURLs[index],
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                    width: 80.0,
                                                                                    height: 80.0,
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                                    ),
                                                                                  ))
                                                                          // AssetImage(
                                                                          //     aviators[index]
                                                                          //         .imageUrl),
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: EdgeInsets.all(5),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "Connect anonymously with your krush",
                                        style: TextStyle(
                                            color: Color(0xffFF5252),
                                            fontSize: 20),
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                          "Your krush will never know who you are,",
                                          style: TextStyle(
                                              color: Color(0xffFF5252)
                                                  .withOpacity(0.8),
                                              fontSize: 15),
                                          maxLines: 1),
                                      AutoSizeText("unless you reveal yourself",
                                          style: TextStyle(
                                              color: Color(0xffFF5252)
                                                  .withOpacity(0.8),
                                              fontSize: 15),
                                          maxLines: 1),
                                    ]),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).accentColor)),
                                // height: 50,
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                  String formattedNumber =
                                      numberFormatRepository.changeNumber(
                                          krushNumberController.text);
                                  if (formattedNumber.length < 10) {
                                    T.message(
                                        "Please enter valid Mobile Number.");
                                  } else if (chatNameController.text.length <
                                          0 ||
                                      krushNameController.text.length < 0 ||
                                      GetAvatarRepository.avatarURLs[
                                              selectedAvatarIndex] ==
                                          null) {
                                    T.message("Please fill all fields.");
                                  } else {
                                   
                                    formattedNumber = formattedNumber.substring(formattedNumber.length-10);

                                     String userPhoneNumber = await UserSettingsManager.getUserPhone();
                          if(userPhoneNumber == selectedCountryCode + formattedNumber){
                            T.message("You can't send a krush request to yourself.");
                          }else{
                            UserSettingsManager.getUserToken()
                                        .then((token) async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      bool result = await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: false,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight:
                                                      Radius.circular(8))),
                                          builder: (context) => StatefulBuilder(
                                              builder: (BuildContext context,
                                                      setState) =>
                                                  ConfirmAddKrushDialog(
                                                      selectedCountryCode +
                                                          formattedNumber,
                                                      krushNameController.text,
                                                      chatNameController.text,
                                                      commentController.text,
                                                      GetAvatarRepository
                                                          .avatarURLs[
                                                              selectedAvatarIndex]
                                                          .toString()
                                                      )));
                                            if(result == true)
                                            Navigator.of(context).pop(true);
                                    });
                          }
                                    
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23)),
                                child: Text(
                                  'Add Krush',
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
                  ));
            }));
  }

  Future selectContacts() async {
    if (await Permission.contacts.request().isGranted) {
      var contact = await Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => ContactsPage()));
      if (contact != null) {
        setState(() {
          krushNumberController.text = contact;
        });

        // setState(() {
        //   if (!phoneNumberController.text.contains("+")) {
        //     phone_validate = false;
        //   } else {
        //     phone_validate = true;
        //   }
        // });
      }
    }
  }

  String changeNumber(String number) {
    bool hasCountryCode = false;
    if (number.contains("+")) {
      hasCountryCode = true;
    } else {
      hasCountryCode = false;
    }

    number = number.replaceAll(RegExp(r'\D+'), '');
    if (hasCountryCode) {
      number = "+" + number;
    } else {
      number = "+1" + number;
    }
    return number;
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
}
