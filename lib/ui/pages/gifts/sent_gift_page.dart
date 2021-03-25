import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import '../../../bloc/gift_sent_bloc/gift_sent_bloc_bloc.dart';
import '../../../app/shared_prefrence.dart';
import '../../../repositories/request_action_repository.dart';
import '../../../utils/T.dart';
import '../../../utils/progress_bar.dart';
import '../../../model/message_model.dart';
import '../../../utils/utils.dart';
import 'confirm_gift_page.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:krushapp/repositories/ads_repository.dart';

class SentGiftTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SentRequestPageState();
  }
}

class _SentRequestPageState extends State<SentGiftTab>
    with AutomaticKeepAliveClientMixin<SentGiftTab> {
  Function wp;
  RequestActionRepository requestActionRepository = RequestActionRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return BlocBuilder(
        cubit: context.bloc<GiftSentBloc>(),
        builder: (BuildContext context, GiftSentBlocState state) {
          return Container(
              child: ListView(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    state is SearchStateLoading
                        ? Container(
                            height: wp(30),
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ),
                            ))
                        : state is SearchStateError
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Error Fetching Conversations'),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    RaisedButton(
                                        child: Text('Retry'),
                                        onPressed: () {
                                          context.bloc<GiftSentBloc>().add(GiftSentListChanged());
                                        })
                                  ],
                                ),
                              )
                            : state is SearchStateSuccess
                                ? Container(
                                    child:
                                        state.sentGifts == null ||
                                                state.sentGifts.data.giftSent
                                                        .length ==
                                                    0
                                            ?  Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children:[
                                          Container(
                                                margin: EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Center(
                                                  child: Text(
                                                      "You haven't sent any gifts!"),
                                                ),
                                              ),
                                          BlocBuilder(
                cubit: context.bloc<AdsBloc>(),
                builder:(context, state){
                  if(state is ToShowAd){
                    if(state.toShow){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                       Container(
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
                              
                          
                        ],
                      );
                    }else{
                      return Container();
                    }
                  }else{
                      return Container();
                      }
                  
                } )
                                        ]
                                      )
                                            : Container(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      state.sentGifts == null
                                                          ? 0
                                                          : state.sentGifts.data
                                                              .giftSent.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8,
                                                                    top: 8,
                                                                    bottom: 8),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                CircleAvatar(
                                                                  radius: 30,
                                                                  child: CachedNetworkImage(
                                                                      imageUrl: state.sentGifts.data.giftSent[index].receiverAvatar == null ? "" : state.sentGifts.data.giftSent[index].receiverAvatar,
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                            width:
                                                                                80.0,
                                                                            height:
                                                                                80.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                            ),
                                                                          )),
                                                                ),
                                                                // CircleAvatar(
                                                                //   radius: 24,
                                                                //   backgroundImage:
                                                                //   AssetImage(state.sentGifts.data.sentGifts[index]
                                                                //       .receiverAvatar == null || state.sentGifts.data.sentGifts[index]
                                                                //       .receiverAvatar == ""? "assets/images/avatar1.png":getAvatarImage(
                                                                //                       state.sentGifts.data.sentGifts[index]
                                                                //       .receiverAvatar),
                                                                // ),),

                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.35,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      AutoSizeText(
                                                                        state
                                                                            .sentGifts
                                                                            .data
                                                                            .giftSent[index]
                                                                            .name,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 22),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                               

                                                                mFlex(),

                                                                state
                                                                            .sentGifts
                                                                            .data
                                                                            .giftSent[
                                                                                index]
                                                                            .hasAccepted ==
                                                                        "accepted"
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Colors
                                                                            .green)
                                                                    : Container(),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                state
                                                                            .sentGifts
                                                                            .data
                                                                            .giftSent[index]
                                                                            .hasAccepted ==
                                                                        "accepted"
                                                                    ? FlatButton(
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
                                                                            () {
                                                                          
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ConfirmGiftPage(status: state
                                                                              .sentGifts.data.giftSent[index]
                                                                              .hasAccepted, krushName: state.sentGifts.data.giftSent[index].name, products: state.sentGifts.data.giftSent[index].products, orderId: state.sentGifts.data.giftSent[index].id.toString())),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Pay Now",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: state.sentGifts.data.giftSent[index].hasAccepted == "Shipped." ? Colors.blue : Colors.red)),
                                                                        color: Colors
                                                                            .white,
                                                                        textColor: state.sentGifts.data.giftSent[index].hasAccepted ==
                                                                                "Shipped."
                                                                            ? Colors.blue
                                                                            : Colors.red,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ConfirmGiftPage(status: state.sentGifts.data.giftSent[index].hasAccepted, krushName: state.sentGifts.data.giftSent[index].name, products: state.sentGifts.data.giftSent[index].products, orderId: state.sentGifts.data.giftSent[index].id.toString())),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          state
                                                                              .sentGifts
                                                                              .data
                                                                              .giftSent[index]
                                                                              .hasAccepted,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 1,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ))
                                : Container()
                  ]));
        });
  }

  String getAvatarImage(String senderAvatar) {
    String imagUrl = "";

    int j = aviators.indexWhere((note) => note.name.contains(senderAvatar));
    if (j < 0 || j >= aviators.length) {
      j = 0;
    }
    imagUrl = aviators[j].imageUrl;
    return imagUrl;
  }
}
