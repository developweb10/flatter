import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/app/theme.dart';
import 'package:krushapp/model/message_model.dart';
import 'package:krushapp/ui/pages/home/main_page.dart';
import 'package:krushapp/utils/T.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:krushapp/utils/utils.dart';
import 'package:krushapp/repositories/date_of_birth_repository.dart';
import '../../../repositories/add_krush_with_reveal_info_repo.dart';
import 'dart:io';

class RevealInformationPage extends StatefulWidget {
  Map args;

  RevealInformationPage(this.args);

  @override
  _RevealInformationPageState createState() => _RevealInformationPageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _RevealInformationPageState extends State<RevealInformationPage> {
  Function wp;

  File _image;
  BuildContext _context;
  DateTime _dateTime;
  String _currentSelectedValue;
  TextEditingController dobController_DUPLICATE = new TextEditingController();
  final nameFocus = FocusNode();
  final dateFocus = FocusNode();
  DateOfBirthRepository dateOfBirthRepository = DateOfBirthRepository();
  AddKrushWithRevealInfoRepo addKrushWithRevealInfoRepo =
      AddKrushWithRevealInfoRepo();
  TextEditingController realNameController = new TextEditingController();

  TextEditingController dateOFBirthController = new TextEditingController();

  TextEditingController genderController = new TextEditingController();
  File imageFile;
  AppState appstate;

  String krushPhoneNumber;
  String krushName;
  String krushChatName;
  String krushComment;
  String avatarUrl;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.args != null) {
      krushPhoneNumber = widget.args['krushPhoneNumber'];
      krushName = widget.args['krushName'];
      krushChatName = widget.args['krushChatName'];
      krushComment = widget.args['krushComment'];
      avatarUrl = widget.args['avatarUrl'];
    }

    appstate = AppState.free;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
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
                      height: MediaQuery.of(context).size.height * 0.85,
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
                                    height: MediaQuery.of(context).size.height *
                                        0.30,

                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
//  Center(child:  Image.asset("assets/images/krush_number_top_background.png" ,height: MediaQuery.of(context).size.height*0.25)),
                                        Center(
                                            child: Image.asset(
                                                "assets/images/reveal_page.png",
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25))
                                      ],
                                    ),
                                  ),
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
                                                0.8,
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //   "Enter your Full Name", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                  // ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    //  height: 20,
                                                    child: TextField(
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      controller:
                                                          realNameController,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                        labelText:
                                                            "Enter your Full Name",
                                                        //Change this value to custom as you like
                                                        isDense:
                                                            true, // and add this line
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
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            // height: 50,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime(2000),
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime.now())
                                              .then((date) {
                                            setState(() {
                                              dateOFBirthController.text =
                                                  dateOfBirthRepository
                                                      .changeDOB(date);
                                              _dateTime = date;
                                            });
                                          });
                                        },
                                        child: Row(
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //  Text(
                                                    //   "Date of Birth", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                    // ),
                                                    Container(
                                                        // height: 30,
                                                        child: IgnorePointer(
                                                      child: TextFormField(
                                                        controller:
                                                            dateOFBirthController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                  vertical:
                                                                      5), //Change this value to custom as you like
                                                          isDense: true,
                                                          labelText:
                                                              "Date of Birth", // and add this line
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ))
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
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor)),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //   "Gender",
                                                  //   style: Theme.of(context)
                                                  //       .textTheme
                                                  //       .subtitle2
                                                  //       .apply(
                                                  //           color: Theme.of(
                                                  //                   context)
                                                  //               .primaryColor,
                                                  //           fontSizeFactor:
                                                  //               0.9),
                                                  // ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    child: FormField<String>(
                                                      builder: (FormFieldState<
                                                              String>
                                                          state) {
                                                        return DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              String>(
                                                            hint: Text(
                                                              "Gender",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            iconDisabledColor:
                                                                Colors
                                                                    .transparent,
                                                            value:
                                                                _currentSelectedValue,
                                                            isDense: true,
                                                            onChanged: (String
                                                                newValue) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      new FocusNode());
                                                              setState(() {
                                                                _currentSelectedValue =
                                                                    newValue;
                                                                genderController
                                                                        .text =
                                                                    _currentSelectedValue;
                                                              });
                                                            },
                                                            items: <String>[
                                                              'Male',
                                                              'Female',
                                                              'Other'
                                                            ].map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: Text(
                                                                  value,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (appstate != AppState.free) {
                                            await _clearImage();
                                          }
                                          _pickImage();

                                          // else if (appstate == AppState.picked)
                                          //   _cropImage(imageFile);
                                          // else if (appstate == AppState.cropped)
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                // padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    Stack(children: [
                                                      CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        backgroundImage:
                                                            imageFile == null
                                                                ? Image.asset(
                                                                        "assets/images/ic_user.png")
                                                                    .image
                                                                : FileImage(
                                                                    imageFile),
                                                        //     child:  Container(
                                                        //   width: 70.0,
                                                        //   height: 70.0,
                                                        //   decoration:
                                                        //       new BoxDecoration(
                                                        //     color:
                                                        //         Colors.redAccent,
                                                        //     shape:
                                                        //         BoxShape.circle,
                                                        //   ),
                                                        //   // child:  imageFile ==
                                                        //   //           null
                                                        //   //       ? Image.asset(
                                                        //   //           "assets/images/ic_user.png")
                                                        //   //       : Image.file(
                                                        //   //           imageFile),
                                                        // ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 35, left: 45),
                                                        child: Icon(
                                                          Icons.add_circle,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ]),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    AutoSizeText(
                                                        "Add a Profile Picture",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                            fontSize: 18),
                                                        maxLines: 1),
                                                  ],
                                                )

                                                // height: 50,
                                                ),
                                          ],
                                        ),
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
                                                    "Reveal Information",
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
                            if (realNameController.text.isEmpty ||
                                genderController.text.isEmpty ||
                                _dateTime == null) {
                              T.message("Fill all fields.");
                            } else {
                              ProgressBar.client.showProgressBar(context);
                              
                              addKrushWithRevealInfoRepo
                                  .registerUserWithKrush(
                                      this.krushPhoneNumber,
                                      this.krushName,
                                      this.krushChatName,
                                      this.krushComment,
                                      realNameController.text,
                                      genderController.text,
                                      _dateTime.toIso8601String(),
                                      this.avatarUrl,
                                      await UserSettingsManager.getUserToken())
                                  .then((data) async {
                                ProgressBar.client.dismissProgressBar();
                                if (data == null) {
                                  T.message("Something went wrong");
                                } else {
                                  if (data.status) {
                                    if (data.data.user.stripeCustomerId ==
                                        null) {
                                      // await ApiClient.apiClient.GetStripeId(widget.token,data.data.user.mobileNumber).then((stripeValue) {
                                      //   UserSettingsManager.setStripeId(stripeValue["data"]["customerId"]);
                                      // });
                                    } else {
                                      UserSettingsManager.setStripeId(
                                          data.data.user.stripeCustomerId);
                                    }
                                    UserSettingsManager.setUserID(
                                        data.data.profile.userId.toString());
                                    UserSettingsManager.setUserName(
                                        data.data.profile.displayName ?? null);
                                    UserSettingsManager.setEmail(
                                        data.data.user.email ?? null);
                                    UserSettingsManager.setUserImage(
                                        data.data.profile.profilePic ?? null);
                                    UserSettingsManager.setUserPhone(
                                        data.data.user.mobileNumber ?? null);
                                    UserSettingsManager.setUserGender(
                                        data.data.profile.gender ?? null);
                                    UserSettingsManager.setUserDOB(data
                                            .data.profile.dateOfBirth
                                            .toIso8601String() ??
                                        null);
                                    UserSettingsManager.setuserCoins(
                                        data.data.user.coins ?? 0);
                                    UserSettingsManager
                                        .setFreeAcceptRequestsAllowed(data.data
                                                .user.freeAcceptsAvailable ??
                                            0);
                                    UserSettingsManager
                                        .setFreesendRequestssAllowed(data
                                                .data
                                                .user
                                                .freeSendRequestAvailabled ??
                                            0);
                                    UserSettingsManager.setKrushToggle(data.data
                                            .user.enableNewKrushNotification ??
                                        0);
                                    UserSettingsManager.setMessageToggle(data
                                            .data
                                            .user
                                            .enableNewChatMessageNotification ??
                                        0);
                                    UserSettingsManager.setFreeAdsViewed(
                                        data.data.user.freeAdsViewed ?? 0);
                                    UserSettingsManager.setSigninStatus(true);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/MainScreen',
                                            (Route<dynamic> route) => false, arguments: imageFile);
                                  } else {
                                    T.message(data.reason);
                                  }
                                }
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                          child: Text(
                            'Get Started',
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
                            Container(
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
                          ],
                        )))
              ],
            )));
  }



  Future<Null> _pickImage() async {
    try {
      final pickedFile =  await ImagePicker().getImage(source: ImageSource.gallery);
      // final  pickedFile = await ImagePicker.pickImage(
      //         source: ImageSource.gallery,);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        appstate = AppState.picked;
      });
      _cropImage();
    }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Photo Access Denied'),
              content: Text(
                  'Krushin requires photos access to set a profile picture.'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      AppSettings.openAppSettings();
                      Navigator.of(context).pop();
                    },
                    child: Text('Open Settings'))
              ],
            );
          },
        );
      }
    }
    
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Theme.of(context).platform == TargetPlatform.android
            ? [
              CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.redAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
          rectHeight: 80,
          rectWidth: 80
          
        ));
    if (croppedFile != null) {
      // imageFile = croppedFile;

      setState(() {
        imageFile =  File(croppedFile.path);
        appstate = AppState.cropped;
      });
    } else {
      _clearImage();
    }
  }

  void _clearImage() {
    //
    setState(() {
      imageFile = null;
      appstate = AppState.free;
    });
  }
}
