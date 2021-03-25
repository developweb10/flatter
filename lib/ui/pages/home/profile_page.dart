import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/ui/pages/settings/block_contacts_screen.dart';
import 'package:krushapp/ui/pages/settings/support_page.dart';
import 'package:krushapp/ui/pages/subscriptions_revenuecat/manage_subscription_revenuecat.dart';
import '../../../app/shared_prefrence.dart';
import '../../../bloc/account_page_bloc/account_page_bloc.dart';
import '../../../model/get_user_response.dart';
import '../login/login_page.dart';
import '../settings/settings_page.dart';
import '../../../utils/utils.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:krushapp/repositories/ads_repository.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  Function wp;
  String profileImageUrl;
  String displayName;
  UserResponse userResponse;
  @override
  bool get wantKeepAlive => true;

  

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0), // here the desired height
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFfe4a49), Color(0xFFfff6060)
                      // Color(0xFFff6060),
                      // Color(0xFFff6060),
                    ]),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: BlocBuilder(
            cubit: context.bloc<AccountPageBloc>(),
            builder: (BuildContext context, AccountPageState state) {
              if (state is AllInfoLoaded) {
                profileImageUrl = state.userResponse.data.profile?.profilePic ??
                    "https://ramcotubular.com/wp-content/uploads/default-avatar.jpg";
                displayName = state.userResponse.data.profile.displayName;
                userResponse = state.userResponse;
              }
              if (state is ProfileImageUpdated) {
                profileImageUrl = state.imageUrl ??
                    "https://ramcotubular.com/wp-content/uploads/default-avatar.jpg";
              } else if (state is ProfileInfoUpdated) {
                displayName = state.userResponse.data.profile.displayName;
              }
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: wp(5), vertical: wp(5)),
                child: state is AllInfoLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      )
                    : ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: profileImageUrl ??
                                  "https://ramcotubular.com/wp-content/uploads/default-avatar.jpg",
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
                            Flexible(
                              child: ListTile(
                                  dense: false,
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                                        width: MediaQuery.of(context).size.width*0.6,
                                                        child: AutoSizeText(
                                        displayName??"",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800),
                                        maxLines: 1,
                                      ),) ,
                                      
                BlocBuilder(
                cubit: context.bloc<AdsBloc>(),
                builder:(context, state){
                  if(state is ToShowAd){
                    if(state.toShow){
                      return Container();
                    }else{
                      return Icon(Icons.verified_user, color: Colors.redAccent, size: 24);
                    }
                  }else{
                      return Icon(Icons.verified_user, color: Colors.redAccent, size: 24);
                      }
                  
                } )
                                    ],
                                  )),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.account_circle,
                            color: Color(0xffFF5252),
                            size: 30,
                          ),
                          title: Text(
                            "Account Details",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .apply(color: Color(0xffFF5252)),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, "/AccountPage",
                                arguments: {
                                  'userResponse': userResponse
                                });

                                     
                          },
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.headset_mic,
                            color: Color(0xffFF5252),
                            size: 30,
                          ),
                          title: Text(
                            "Support",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .apply(color: Color(0xffFF5252)),
                          ),
                          onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        SupportPage())),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.settings,
                            color: Color(0xffFF5252),
                            size: 30,
                          ),
                          onTap: () {
                            navigateTo(context, SettingsPage());
                          },
                          title: Text(
                            "Settings",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .apply(color: Color(0xffFF5252)),
                          ),
                        ),
                        SizedBox(height: 15),
                        ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.power_settings_new,
                              color: Color(0xffFF5252),
                              size: 30,
                            ),
                            title: Text(
                              "Logout",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .apply(color: Color(0xffFF5252)),
                            ),
                            onTap: () {
                              logout();
                            }),

                            BlocBuilder(
                cubit: context.bloc<AdsBloc>(),
                builder:(context, state){
                  if(!(state is ToShowAd) || !(state.toShow)){
                  return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 15),

                        ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.block,
                              color: Color(0xffFF5252),
                              size: 30,
                            ),
                            title: Text(
                              "Block Contacts",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .apply(color: Color(0xffFF5252)),
                            ),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BlockContactsScreen())))
                        ],
                      );
                  }else{
                    return Container();
                  }
                  
                  }
                  
                 ),

SizedBox(height: 15),
                        ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.settings,
                            color: Color(0xffFF5252),
                            size: 30,
                          ),
                          onTap: () async {
                          //   String packageName = "com.nonestop.krushin";
                          //   String sku = "krushin_sub_9.95";
                          // await launch("https://play.google.com/store/account/subscriptions?sku=$sku&package=$packageName");
                         navigateTo(context, ManageSubscriptionRevenuecat());
                       
                          },
                          title: Text(
                            "Manage Subscription",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .apply(color: Color(0xffFF5252)),
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

                        
                      ]),
              );
            }));
  }

  logout() async {
    await FirebaseAuth.instance.signOut().then((value) {
      UserSettingsManager.setUserID(null);
      UserSettingsManager.setUserName(null);
      UserSettingsManager.setEmail(null);
      UserSettingsManager.setUserImage(null);
      UserSettingsManager.setUserToken(null);
      UserSettingsManager.setUserPhone(null);
      UserSettingsManager.setUserGender(null);
      UserSettingsManager.setUserDOB(null);
      UserSettingsManager.setFreeAcceptRequestsAllowed(null);
      UserSettingsManager.setFreesendRequestssAllowed(null);
      UserSettingsManager.setKrushToggle(null);
      UserSettingsManager.setMessageToggle(null);
      UserSettingsManager.setStripeId(null);
      UserSettingsManager.setUserImage(null);
      UserSettingsManager.setuserCoins(null);
      UserSettingsManager.setFreeAdsViewed(null);
      UserSettingsManager.setsubscriptionShownStatus(null);
      UserSettingsManager.setSubsciptionStatus(null);
      UserSettingsManager.setSigninStatus(false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginPage();
          },
        ),
      );
    });
  }
}
