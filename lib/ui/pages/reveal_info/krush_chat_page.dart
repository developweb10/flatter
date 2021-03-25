import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krushapp/app/theme.dart';
import 'package:krushapp/model/aviator_model.dart';
import 'package:krushapp/model/message_model.dart';
import 'package:krushapp/repositories/get_avatars_repository.dart';
import 'package:krushapp/utils/utils.dart';

import 'reveal_info_page.dart';

class KrushChatPage extends StatefulWidget {
  String krushPhoneNumber;

  KrushChatPage(this.krushPhoneNumber);

  @override
  _KrushChatPageState createState() => _KrushChatPageState();
}

class _KrushChatPageState extends State<KrushChatPage> {
  Function wp;

  List<Aviator> avatarList = List();
  int selectedAvatarIndex;
  TextEditingController krushChatNameController = new TextEditingController();

  TextEditingController krushNameController = new TextEditingController();

  TextEditingController krushCommentController = new TextEditingController();

  int selectIndex;

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
                      height: MediaQuery.of(context).size.height * 0.9,
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
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
                                                  //   "Enter your krush's real name", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
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
                                                          krushNameController,
                                                      textInputAction:
                                                          TextInputAction.done,
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
                                                            "Enter your krush's real name", // and add this line
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
                                                children: [
                                                  // Text(
                                                  //   "Enter your anonymous chat name", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                  // ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    // padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            controller:
                                                                krushChatNameController,
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
                                                                  "Enter your anonymous chat name", // and add this line
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
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //   "Enter what you want to say to your krush", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                  // ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    // padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            controller:
                                                                krushCommentController,
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
                                                              isDense: true,
                                                              labelText:
                                                                  "Enter what you want to say to your krush", // and add this line
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
                                                0.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                 Text(
                                                            "Chose your Anonymous Avatar", style: Theme.of(context).textTheme.subtitle2.apply(color: Theme.of(context).primaryColor, fontSizeFactor: 0.9),
                                                          ),

                                                Container(
                                                  height: wp(21),
                                                  child: ListView.builder(
                                                    // padding: EdgeInsets.only(top: 2),
                                                    // shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: GetAvatarRepository.avatarURLs.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedAvatarIndex =index;
                                                            //  radius = 11;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  wp(1)),
                                                          child: Column(
                                                            children: <Widget>[
                                                              AnimatedContainer(
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:  Colors
                                                                          .black26,
                                                                  radius: selectedAvatarIndex ==
                                                                          index
                                                                      ? wp(9.5)
                                                                      : wp(8),
                                                                  child:
                                                                  CachedNetworkImage(imageUrl: GetAvatarRepository.avatarURLs[index],
                                                                    imageBuilder: (context, imageProvider) => Container(
    width: 80.0,
    height: 80.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: imageProvider, fit: BoxFit.cover),
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
                                                ),
                                              ],
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
                                                    "Being Anonymous",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                    maxLines: 1,
                                                  ),
                                                  AutoSizeText(
                                                      "It’s always a good idea to choose a unique username,",
                                                      style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          fontSize: 15),
                                                      maxLines: 1),
                                                  AutoSizeText(
                                                      " one easy to remember but not personally identifiable.",
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
                        // margin: EdgeInsets.only(top: 5),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/RevealInformationPage', arguments: {'krushPhoneNumber':widget.krushPhoneNumber, 'krushName': krushNameController.text, 'krushChatName': krushChatNameController.text, 'krushComment':   krushCommentController.text, 'avatarUrl': GetAvatarRepository.avatarURLs[selectedAvatarIndex].toString()});
                            // navigateTo(
                            //     context,
                            //     RevealInformationPage(
                            //         widget.krushPhoneNumber,
                            //         krushNameController.text,
                            //         krushChatNameController.text,
                            //         krushCommentController.text,
                            //         GetAvatarRepository.avatarURLs[selectedAvatarIndex].toString()));
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

  _mFlexValue(int f) {
    return Flexible(
      flex: f,
      child: Container(),
    );
  }

  _mHeight(double h) {
    return Container(
      height: h,
    );
  }

  _mFlex() {
    return Flexible(
      flex: 1,
      child: Container(),
    );
  }
}
