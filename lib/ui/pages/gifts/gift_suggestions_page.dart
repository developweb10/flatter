
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import 'package:krushapp/bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'package:krushapp/model/chat_conversation_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:krushapp/repositories/ads_repository.dart';

import 'package:krushapp/utils/shapes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'gift_listing_page.dart';

class GiftSuggestionPage extends StatefulWidget {
  @override
  _GiftSuggestionPageState createState() => _GiftSuggestionPageState();
}

class _GiftSuggestionPageState extends State<GiftSuggestionPage>
    with TickerProviderStateMixin {
  Function wp;
  DateTime dob_dateTime;

  int toView = 0;
  String adLink = '';

      getLink() {
    setState(() {
      adLink = AdsRepository.getNewAd();
    });
  }

   void _handleLoad(String value) {
    setState(() {
      toView = 1;
    });
  }

  @override
  void initState() {
 getLink() ;
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
                            "Send Gift",
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
          child:          Container(
                padding: EdgeInsets.only(top: 20),
                child: BlocBuilder(
                    cubit: context.bloc<ChatConversationsBloc>(),
                    builder: (context, state) {
                      if (state is ChatConversationsLoaded) {
                        return ValueListenableBuilder(
                          builder: (context, box, child) {
                            box = box as Box<ChatsConversationModel>;
                           
                            if ((box as Box<ChatsConversationModel>)
                                .values
                                .isEmpty) {
                              return Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 8),
                                alignment: Alignment.center,
                                child: Column(children: [
                                  Text("You don't have any krushes!"),
                                   Text("Send a krush request."),
                                ],)
                              );
                            }

                            return AnimationLimiter(
                              child:  Column(
                                    
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    
                                    Container(
                margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: Text(
                  'Suggestions',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
 ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: box.length,
                                      itemBuilder: (context, index) {
                                      
                                        return buildListItem(index, context,
                                            box.getAt(index).chatName, box.getAt(index).avatar, box.getAt(index).relationId);
                                      }),
                                  ],)
                            );
                          },

                               valueListenable: Hive.box<ChatsConversationModel>(
                                  'conversationsBox').listenable(),
                        );
                      } else if (state is ChatConversationsError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Error Fetching Conversations'),
                              SizedBox(
                                height: 8,
                              ),
                              RaisedButton(
                                  child: Text('Retry'),
                                  onPressed: () {
                                    context.bloc<ChatConversationsBloc>().add(GetUserConversations());
                                  })
                            ],
                          ),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        );
                    }),
              ),
        ),
      ),
    );
  }

      Widget buildListItem(int index, BuildContext context, String chatName, String avatar, int relationId) {

         return Column(children: [
Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10),
                                  child:  Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(children: [
CircleAvatar(
                                              radius: 30,               
                                            child:
                                              CachedNetworkImage(imageUrl: avatar ?? '',
                                                                    imageBuilder: (context, imageProvider) => Container(
    width: 120.0,
    height: 120.0,
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
                         
                                      
                                          SizedBox(width: wp(2.5)),
                                          Text(
                                            chatName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ],),

                                           FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.red)),
                                                                        color: Colors
                                                                            .redAccent,
                                                                        textColor:
                                                                            Colors.white,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () {
                                                                           Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => GiftListingPage(relationId)),
  ); 
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Gift",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                          ),
                                                                        ),
                                                                      )
                                          
                                        ],
                                      ),),
BlocBuilder(
                cubit: context.bloc<AdsBloc>(),
                builder:(context, state){
                  if(state is ToShowAd){
                    if(state.toShow){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          index%4 == 0
                              ? adLink != null
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 20.0, left: 20),
                                          child: Container(
                                              height: toView == 1 ? 50 : 1,
                                              child: WebView(
                                                initialUrl: Uri.dataFromString(
                                                        adLink,
                                                        mimeType: 'text/html')
                                                    .toString(),
                                                // initialUrl: '',

                                                javascriptMode:
                                                    JavascriptMode.unrestricted,
                                                onPageFinished: _handleLoad,

                                                navigationDelegate:
                                                    (NavigationRequest
                                                        request) {
                                                  launch(request.url);
                                                  return NavigationDecision
                                                      .prevent;
                                                },
                                              )),
                                        )
                                      ],
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          bottom: 10.0, top: 10),
                                      child: AdmobBanner(
                                        adUnitId:
                                            AdsRepository.getBannerAdUnitId(),
                                        adSize: AdmobBannerSize.BANNER,
                                        listener: (AdmobAdEvent event,
                                            Map<String, dynamic> args) {
                                          // handleEvent(event, args, 'Banner');
                                        },
                                        onBannerCreated:
                                            (AdmobBannerController controller) {
                                          // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                                          // Normally you don't need to worry about disposing this yourself, it's handled.
                                          // If you need direct access to dispose, this is your guy!
                                          // controller.dispose();
                                        },
                                      ),
                                    )
                              : Container(),
                          index%4 == 0 && (toView == 1 || adLink == null)
                              ? Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF3F4F9),
                                )
                              : Container(),
                        ],
                      );
                    }else{
                      return Container();
                    }
                  }else{
                      return Container();
                      }
                  
                } ),

             Divider(
                                  // height: 1,
                                  // thickness: 1,
                                  color: Color(0xFFF3F4F9),
                                )


         ],) ;
  }
}
