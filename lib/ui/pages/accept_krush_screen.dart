import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/app/theme.dart';
import 'package:krushapp/model/recieve_request.dart';
import 'package:krushapp/repositories/request_action_repository.dart';
import 'package:krushapp/utils/Constants.dart';
import 'package:krushapp/utils/T.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AcceptKrushScreen extends StatefulWidget {
  RequestReceived requestReceived;
  AcceptKrushScreen(this.requestReceived);

  @override
  State<StatefulWidget> createState() {
    return _AcceptKrushScreenState();
  }
}

class _AcceptKrushScreenState extends State<AcceptKrushScreen> {


  final RequestActionRepository requestActionRepository =
      RequestActionRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
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
                            height: MediaQuery.of(context).size.height * 0.80,
                            child: Card(
                                color: Color(0xffF2F2F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Center(child: Container(alignment: Alignment.center,
                                     height: MediaQuery.of(context).size.height * 0.50,
                             
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
 AutoSizeText(
                                                    "Hey! You have got a",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25),
                                                    maxLines: 1,
                                                  ),
                                    SizedBox(
                                      height: 10,

                                    ),

                                                                        AutoSizeText(
                                                    "Krush Request",
                                                    style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 22),
                                                    maxLines: 1,
                                                  ),
                                      ],
                                    ),


                                Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: widget.requestReceived.senderAvatar??"https://www.iconfinder.com/data/icons/circle-avatars-1/128/039_girl_avatar_profile_woman_headband-512.png",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 75.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(
                              width: 10
                            ),
                              Text(
                                        widget.requestReceived.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800),
                                        maxLines: 1,
                                      ),
                          ],
                        ),   

                        Column(children: [
Container(
                          width:  MediaQuery.of(context).size.width * 0.50,
                          child:    Text("Message for you",  style: TextStyle(
                                                        fontSize: 15),),
                        ),
                        SizedBox(
                          height: 5,
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
                                                0.5,
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.requestReceived.comment,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                 
                                                
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

                                  
                        ],),

                          Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.red)),
                                                                        color: Colors
                                                                            .white,
                                                                        textColor:
                                                                            Colors.red,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () async {
                                                                  applyAction("${ApiClient.apiClient.baseUrl}/reject_krush", widget.requestReceived.relationId, await UserSettingsManager.getUserToken())  ;
                        
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "No, Decline",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                   SizedBox(
                                                                     width: 10,
                                                                   )   ,
                                                                      FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.green)),
                                                                        color: Colors
                                                                            .white,
                                                                        textColor:
                                                                            Colors.green,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () async {
                                                                      applyAction("${ApiClient.apiClient.baseUrl}/accept_krush", widget.requestReceived.relationId, await UserSettingsManager.getUserToken())  ;
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Yes, Connect",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.0,
                                                                          ),
                                                                        ),
                                                                      )
                                        ],
                                      ),
                        
                                  ],
                                ),
                                )
                                ,) 

                                
                                ),
                          ),
                        
                         
                        ],
                      )),
                      // SafeArea(
                      //     child: Container(
                      //         margin: EdgeInsets.only(
                      //           top: MediaQuery.of(context).size.height * 0.05,
                      //           left: MediaQuery.of(context).size.width * 0.05,
                      //         ),
                      //         child: Row(
                      //           mainAxisSize: MainAxisSize.min,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             InkWell(
                      //               onTap: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //               child: Container(
                      //                 width: 28.0,
                      //                 height: 28.0,
                      //                 decoration: new BoxDecoration(
                      //                   color: Theme.of(context).accentColor,
                      //                   shape: BoxShape.circle,
                      //                 ),
                      //                 child: Center(
                      //                   child: Icon(
                      //                     Icons.arrow_back_ios,
                      //                     color: Colors.black,
                      //                     size: 20,
                      //                   ),
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         )))
                    ])));
                  
          
  }

    applyAction(String url, int relationId, String token) async {
    ProgressBar.client.showProgressBar(context);
    await requestActionRepository
        .applyAction(
            relationId, url, token)
        .then(
      (v) {
        ProgressBar.client.dismissProgressBar();
        T.message(v.message + "");
        if (v.status) {
      Navigator.pushNamed(context, '/RevealInformationPage', arguments: {'krushPhoneNumber':null, 'krushName': null, 'krushChatName': null, 'krushComment':   null, 'avatarUrl': null});
        }
        
      },
    );
  }

}
