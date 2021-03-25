import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'package:krushapp/utils/Constants.dart';
import '../../bloc/bottom_nav_counters_bloc/bottom_nav_counters_bloc.dart';
import '../../repositories/ads_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/shared_prefrence.dart';
import '../../bloc/chat_conversations_bloc/chat_conversations_bloc.dart';
import '../../bloc/krush_recieved_bloc/krush_recieved_bloc_bloc.dart';
import '../../bloc/request_action_bloc/request_action_bloc.dart';
import '../../model/message_model.dart';
import '../../repositories/request_action_repository.dart';
import '../dialogs/cancel_krush_dialog.dart';
import '../dialogs/confirm_request_accept_dialog.dart';
import '../../utils/T.dart';
import '../../utils/progress_bar.dart';
import '../../utils/utils.dart';
import '../../bloc/krush_active_bloc/krush_active_bloc.dart'
    as active;

class ReceiveRequestTab extends StatefulWidget {

  @override
  _ReceiveRequestPageState createState() => _ReceiveRequestPageState();
}

class _ReceiveRequestPageState extends State<ReceiveRequestTab>
    with AutomaticKeepAliveClientMixin<ReceiveRequestTab> {
  String token;
  BuildContext _context;
  String uri = "";
  int coins_left;
  int free_requests;
  Function wp;
  RequestActionBloc requestActionBloc = RequestActionBloc();
  final RequestActionRepository requestActionRepository =
      RequestActionRepository();
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

  showConfirmSheet(int relationId, String uri, String token) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, setState) =>
                ConfirmRequestAcceptDialog(
                    relationId,
                    uri
                    )));
  }

  @override
  void initState() {
    getData();
       getLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return BlocBuilder(
        cubit: context.bloc<KrushRequestBloc>(),
        builder: (BuildContext context, KrushRequestBlocState state) {
          return Container(
              child: ListView(

                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  children: <Widget>[  state is KrushRequestLoading
                  ? Container(
                      height: wp(30),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ))
                  : state is KrushRequestError
                      ? Center(child: Text("Failure fetching reqeusts"))
                      : state is KrushRequestSuccess
                          ? Container(
                              child:
                                  state.recieveRequest == null ||
                                          state.recieveRequest.data
                                                  .requestReceived.length ==
                                              0
                                      ? Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children:[
                                          Container(
                                          alignment: Alignment.topCenter,
                                          margin: EdgeInsets.only(top: 20),
                                          child: Text(
                                              "You don't have any pending requests!"),
                                        ),
                                          BlocBuilder(
                cubit: context.bloc<AdsBloc>(),
                builder:(context, state){
                  if(state is ToShowAd){
                    if(state.toShow){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          adLink != null
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
                                        shrinkWrap: true,
                                          padding: EdgeInsets.all(0),
                                          itemCount:
                                              state.recieveRequest == null
                                                  ? 0
                                                  : state.recieveRequest.data
                                                      .requestReceived.length,
                                          itemBuilder: (context, index) {
                               context.bloc<BottomNavCountersBloc>().add(
                                UpdateCountersEvent(
                                    krushesCounter: state.recieveRequest.data
                                                      .requestReceived.length));
                                            return Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 8, 8),
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
                                                                            .recieveRequest
                                                                            .data
                                                                            .requestReceived[
                                                                                index]
                                                                            .senderAvatar,
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
                                                            //           .requestReceived[
                                                            //               index]
                                                            //           .senderAvatar)),
                                                            // ),\


Expanded(child: Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: AutoSizeText(
                                                                      state.recieveRequest.data.requestReceived[index].name ==
                                                                              null
                                                                          ? ""
                                                                          : 
                                                                          state
                                                                        .recieveRequest
                                                                        .data
                                                                        .requestReceived[
                                                                            index]
                                                                        .name,
                                                                              
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              22),
                                                                    )),) ,
                                                            

                                                            // mFlex(),

                                                            state
                                                                        .recieveRequest
                                                                        .data
                                                                        .requestReceived[
                                                                            index]
                                                                        .status ==
                                                                    "pending"
                                                                ? Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
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
                                                                            () {
                                                                          showConfirmSheet(
                                                                              state.recieveRequest.data.requestReceived[index].relationId,
                                                                              "${ApiClient.apiClient.baseUrl}/accept_krush",
                                                                              this.token);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Accept",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            40,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        child: FlatButton(
                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.red)),
                                                                            color: Colors.white,
                                                                            textColor: Colors.red,
                                                                            padding: EdgeInsets.all(2.0),
                                                                            onPressed: () {
                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  isScrollControlled: false,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                  builder: (context) => StatefulBuilder(
                                                                                      builder: (BuildContext context, setState) => CancelKrushDialog(
                                                                                            relationId: state.recieveRequest.data.requestReceived[index].relationId,
                                                                                            reject: rejectRequest,
                                                                                            block: blockRequest,
                                                                                          )));
                                                                            },
                                                                            child: SvgPicture.asset(
            'assets/svg/cancel_icon.svg',
            height: 17,
            width: 17,
          )),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    state
                                                                        .recieveRequest
                                                                        .data
                                                                        .requestReceived[
                                                                            index]
                                                                        .status,
                                                                    style: TextStyle(
                                                                        color: state.recieveRequest.data.requestReceived[index].status ==
                                                                                "rejected"
                                                                            ? Colors
                                                                                .black
                                                                            : state.recieveRequest.data.requestReceived[index].status == "accepted"
                                                                                ? Colors.green
                                                                                : Colors.red,
                                                                        fontSize: 18),
                                                                  ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Comment: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14),
                                                            ),
                                                            // mHeight(4),
                                                            Container(
                                                              // width: 50,
                                                              child: AutoSizeText(state
                                                                  .recieveRequest
                                                                  .data
                                                                  .requestReceived[
                                                                      index]
                                                                  .comment),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      height: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.5)),

                                                          
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
                  
                } )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                            )
                          : Container()]));
        });
  }

  rejectRequest(int relationId) async {
    ProgressBar.client.showProgressBar(context);
    await requestActionRepository
        .applyAction(
            relationId, "${ApiClient.apiClient.baseUrl}/reject_krush", token)
        .then(
      (v) {
        if (v.status) {
          T.message(v.message + "");
          context.bloc<KrushRequestBloc>().add(KrushRequestListChanged());
          context.bloc<ChatConversationsBloc>().add(GetUserConversations());
        }

        ProgressBar.client.dismissProgressBar();
        Navigator.of(context).pop();
      },
    );
  }

  blockRequest(int relationId) async {
    ProgressBar.client.showProgressBar(context);
    await requestActionRepository
        .applyAction(
            relationId, "${ApiClient.apiClient.baseUrl}/block_krush", token)
        .then(
      (v) {
        if (v.status) {
          T.message(v.message + "");
                  context.bloc<KrushRequestBloc>().add(KrushRequestListChanged());
          context.bloc<ChatConversationsBloc>().add(GetUserConversations());
        }
        ProgressBar.client.dismissProgressBar();
        Navigator.of(context).pop();
      },
    );
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
