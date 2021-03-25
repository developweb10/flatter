import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/subscription_bloc/subscription_bloc_bloc.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import 'package:krushapp/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/shared_prefrence.dart';
import '../../repositories/request_action_repository.dart';
import '../../utils/T.dart';
import '../../utils/progress_bar.dart';
import '../../bloc/krush_sent_bloc/krush_sent_bloc_bloc.dart';
import '../../model/message_model.dart';
import '../../utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SentRequestTab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SentRequestPageState();
  }
}

class _SentRequestPageState extends State<SentRequestTab>
    with AutomaticKeepAliveClientMixin<SentRequestTab> {
  Function wp;
  RequestActionRepository requestActionRepository = RequestActionRepository();
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
    // TODO: implement initState
    getLink();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return BlocBuilder(
        cubit: context.bloc<KrushSentBloc>(),
        builder: (BuildContext context, KrushSentBlocState state) {
          return Container(
              child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                            ?  Center(
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
                             context.bloc<KrushSentBloc>().add(KrushSentListChanged());
                                  })
                            ],
                          ),
                        )
                            : state is SearchStateSuccess
                                ? Container(
                                    child:
                                        state.requestSent == null ||
                                                state.requestSent.data
                                                        .requestSent.length ==
                                                    0
                                            ? Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children:[
                                          Container(
                                              margin: EdgeInsets.only(top: 20),
                                                child: Center(
                                                  child: Text(
                                                      "You haven't sent any request!"),
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
                                            : Container(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.all(0),
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      state.requestSent == null
                                                          ? 0
                                                          : state
                                                              .requestSent
                                                              .data
                                                              .requestSent
                                                              .length,
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
                                                                      imageUrl: state.requestSent.data.requestSent[index].receiverAvatar == null ? "" : state.requestSent.data.requestSent[index].receiverAvatar,
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
                                                                //   AssetImage(state.requestSent.data.requestSent[index]
                                                                //       .receiverAvatar == null || state.requestSent.data.requestSent[index]
                                                                //       .receiverAvatar == ""? "assets/images/avatar1.png":getAvatarImage(
                                                                //                       state.requestSent.data.requestSent[index]
                                                                //       .receiverAvatar),
                                                                // ),),
                                                                Expanded(child: Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: AutoSizeText(
                                                                      state.requestSent.data.requestSent[index].name ==
                                                                              null
                                                                          ? ""
                                                                          : 
                                                                          state
                                                                              .requestSent
                                                                              .data
                                                                              .requestSent[index]
                                                                              .name
                                                                              ,
                                                                      maxLines: 1,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              22),
                                                                    )),) ,
                                                                // mFlex(),

                                                                state
                                                                            .requestSent
                                                                            .data
                                                                            .requestSent[index]
                                                                            .status ==
                                                                        "pending"
                                                                    ? FlatButton(
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
                                                                            () {
                                                                          revokeRequest(state
                                                                              .requestSent
                                                                              .data
                                                                              .requestSent[index]
                                                                              .relationId);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Cancel",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        state
                                                                            .requestSent
                                                                            .data
                                                                            .requestSent[index]
                                                                            .status,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize: 18),
                                                                      ),
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
                                                          ),

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
                                              ))
                                : Container()
                  ]));
        });
  }

  revokeRequest(int relationId) async {
    // token = ;
    ProgressBar.client.showProgressBar(context);
    requestActionRepository
        .revokeRequest(
            relationId,
            "${ApiClient.apiClient.baseUrl}/revoke_krush_request",
            await UserSettingsManager.getUserToken())
        .then(
      (v) {
        T.message(v.message + "");
        if (v.status) {
          context.bloc<KrushSentBloc>().add(KrushSentListChanged());
        }
        ProgressBar.client.dismissProgressBar();
      },
    );
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
