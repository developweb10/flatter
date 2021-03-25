import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import '../../../bloc/bottom_nav_counters_bloc/bottom_nav_counters_bloc.dart';
import '../../../repositories/gift_repository.dart';
import '../../../bloc/gift_recieved_bloc/gift_recieved_bloc_bloc.dart';
import '../../../app/shared_prefrence.dart';
import '../../../model/message_model.dart';
import '../../../utils/utils.dart';
import 'accept_gift_page.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:krushapp/repositories/ads_repository.dart';

class ReceivedGiftTab extends StatefulWidget {

  @override
  _ReceiveGiftPageState createState() => _ReceiveGiftPageState();
}

class _ReceiveGiftPageState extends State<ReceivedGiftTab>
    with AutomaticKeepAliveClientMixin<ReceivedGiftTab> {
  String token;
  BuildContext _context;
  String uri = "";
  int coins_left;
  int free_requests;
  Function wp;

  final GiftRepository giftRepository =
      GiftRepository();

  getData() {

    
    UserSettingsManager.getuserCoins().then((t) {
      setState(() {
        coins_left = t;
      });
    });

    UserSettingsManager.getUserToken().then((t) {
      setState(() {
        token = t;
      });
    });

    UserSettingsManager.getFreeAcceptRequestsAllowed().then((t) {
      setState(() {
        free_requests = t;
      });
    });
  }


  @override
  void initState() {
    getData();
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return BlocBuilder(
        cubit: context.bloc<GiftRecievedBloc>(),
        builder: (BuildContext context, GiftRecievedBlocState state) {
          return Container(
              child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                            physics:
                                                      NeverScrollableScrollPhysics(),
                  children: <Widget>[ state is GiftReceivedLoading
                  ? Container(
                      height: wp(30),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ))
                  : state is GiftReceivedError
                      ? Center(child: Text("Failure fetching reqeusts"))
                      : state is GiftReceivedSuccess
                          ? Container(
                              child:
                                  state.recievedGifts == null ||
                                          state.recievedGifts.data.giftRecieved.length ==
                                              0
                                      ? Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children:[
                                           Container(
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.only(top: 20, bottom: 20),
                                          child: Text(
                                              "You haven't received any gifts!"),
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
                                      : ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          shrinkWrap: true,
                                                    physics:
                                                      NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.recievedGifts == null
                                                  ? 0
                                                  : state.recievedGifts.data
                                                      .giftRecieved.length,
                                          itemBuilder: (context, index) {
                                  int giftCounter = 0;
                                  for (var element in state.recievedGifts.data.giftRecieved) {
                              if (element.hasAccepted == 'pending') {
                                giftCounter = giftCounter + 1;
                              }
                            }
                                            context.bloc<BottomNavCountersBloc>().add(
                                UpdateCountersEvent(
                                    giftsCounter: giftCounter));
                                            return Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 8, 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            CircleAvatar(
                                                                radius: 30,
                                                                child:
                                                                    CachedNetworkImage(
                                                                        imageUrl: state
                                                                            .recievedGifts
                                                                            .data
                                                                            .giftRecieved[
                                                                                index]
                                                                            .receiverAvatar,
                                                                        imageBuilder: (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                              width: 80.0,
                                                                              height: 80.0,
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                                              ),
                                                                            ))),
                                                            // CircleAvatar(
                                                            //   radius: 24,
                                                            //   backgroundImage: AssetImage(
                                                            //       getAvatarImage(state
                                                            //           .recieveRequest
                                                            //           .data
                                                            //           .giftRecieved[
                                                            //               index]
                                                            //           .senderAvatar)),
                                                            // ),\

                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              width: MediaQuery.of(context).size.width*0.35,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoSizeText(
                                                                    // state
                                                                    //     .recievedGifts
                                                                    //     .data
                                                                    //     .giftRecieved[
                                                                    //         index]
                                                                    //     .name,
                                                                    
                                                                    state
                                                                        .recievedGifts
                                                                        .data
                                                                        .giftRecieved[
                                                                            index]
                                                                        .name,
                                                                        overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize:
                                                                            20),
                                                                    minFontSize: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                          mFlex(),

                                                            state
                                                                        .recievedGifts
                                                                        .data
                                                                        .giftRecieved[
                                                                            index]
                                                                        .hasAccepted ==
                                                                    "pending" ?
                                                             

                                                                   FlatButton(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.blue)),
                                                                        color: Colors
                                                                            .white,
                                                                        textColor:
                                                                            Colors.blue,
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        onPressed:
                                                                            () {

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AcceptGiftPage(status: state.recievedGifts.data.giftRecieved[index].hasAccepted,krushName: state.recievedGifts.data.giftRecieved[index].name, products: state.recievedGifts.data.giftRecieved[index].products, orderId: state.recievedGifts.data.giftRecieved[index].id.toString())),
  );

                                                                  
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "View Gift",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      )
                                                                : Text(
                                                                    state
                                                                        .recievedGifts
                                                                        .data
                                                                        .giftRecieved[
                                                                            index]
                                                                        .hasAccepted,
                                                                    style: TextStyle(
                                                                        color: state.recievedGifts.data.giftRecieved[index].hasAccepted ==
                                                                                "Shipped."
                                                                            ? Colors
                                                                                .black
                                                                            : state.recievedGifts.data.giftRecieved[index].hasAccepted == "accepted"
                                                                                ? Colors.green
                                                                                : Colors.red,
                                                                        fontSize: 18),
                                                                  ),
                                                          ],
                                                        ),
                                                        // Row(
                                                        //   children: [
                                                        //     Text(
                                                        //       "Comment: ",
                                                        //       style: TextStyle(
                                                        //           color: Colors
                                                        //               .black,
                                                        //           fontSize: 14),
                                                        //     ),
                                                        //     // mHeight(4),
                                                        //     Container(
                                                        //       // width: 50,
                                                        //       child: AutoSizeText(state
                                                        //           .recievedGifts
                                                        //           .data
                                                        //           .giftRecieved[
                                                        //               index]
                                                        //           .comment),
                                                        //     )
                                                        //   ],
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.5))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                            )
                          : Container()]));
        });
  }


  Color selectColor(String v) {
    if (v == "accepted") {
      return Colors.green;
    } else if (v == "rejected") {
      return Colors.red;
    } else if (v == "blocked") {
      return Colors.black;
    } else {
      return Colors.black;
    }
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

  @override
  bool get wantKeepAlive => true;
}
