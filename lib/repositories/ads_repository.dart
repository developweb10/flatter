import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/bloc/ads_bloc/ads_bloc.dart';
import 'package:krushapp/bloc/krushin_coins_bloc/krushin_coins_bloc.dart';
import 'package:krushapp/utils/Constants.dart';
import 'package:krushapp/utils/T.dart';

class AdsRepository {
  AdsBloc adsBloc;
  RewardedVideoAd videoAd;
  KrushinCoinsBloc krushinCoinsBloc;

  AdsRepository(this.adsBloc, this.videoAd, this.krushinCoinsBloc) {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    this.videoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {

      if (event == RewardedVideoAdEvent.loaded) {
        this.videoAd.show();
        // this.adsBloc.add(ShowAd());
      } else if (event == RewardedVideoAdEvent.rewarded) {

      } else if (event == RewardedVideoAdEvent.failedToLoad) {
       
      }
    };
  }

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    // testDevices: <String>["D6C28ED1C5FB3C8CB2367012028903F7"],
    // keywords: <String>['wallpapers', 'walls', 'amoled'],
    childDirected: false,
  );

  String getAppId() {
    if (Platform.isIOS) {
      return "ca-app-pub-9307372028212142~5137001440";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9307372028212142~7152613081";
    }
    return null;
  }

  String getRewarededAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-9307372028212142/3733679612";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9307372028212142/7600772430";
    }
    return null;
  }

   static String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-9307372028212142/5473732115";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9307372028212142/8358401434";
    }
    return null;
  }

   static String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-9307372028212142/7864496312";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9307372028212142/8011835977";
    }
    return null;
   }

  loadAd() async {
    var value = ApiClient.apiClient.getAdsCount();
    if (value["status"]) {
      if (value["data"]["freeAdsCount"] > 0) {
        await videoAd.load(
            adUnitId: getRewarededAdUnitId(), targetingInfo: targetInfo);
      } else {
        // this.adsBloc.add(LimitExceeded());
        // _showVersionDialog(context);
      }
    } else {
      // this.adsBloc.add(AdShownFailed());
    }
    ;
  }

  updateFreeAds(String token) {
    ApiClient.apiClient.updateFreeAds().then((value) {
      if (value["status"]) {
        UserSettingsManager.setFreeAdsViewed(
            value['data']['user']['freeAdsViewed']);
        krushinCoinsBloc.add(AddCoins(coins: 50));
        // addCoins(50);
      } else {
        T.message("Rewarding failed");
      }
    });
  }



  static String getNewAd(){
    Random random = new Random();
    int randomNumber = random.nextInt(10);

    List<String> ads_iframe = [
"<html><body><iframe id='a5909d62' name='a5909d62' src='https://krushin.io/krushinads/www/delivery/afr.php?zoneid=1&amp;cb=INSERT_RANDOM_NUMBER_HERE' frameborder='0' scrolling='no' width='300' height='50' allow='autoplay'><a href='http://krushin.io/krushinads/www/delivery/ck.php?n=a03d9028&amp;cb=INSERT_RANDOM_NUMBER_HERE' target='_blank'><img src='http://krushin.io/krushinads/www/delivery/avw.php?zoneid=1&amp;cb=INSERT_RANDOM_NUMBER_HERE&amp;n=a03d9028' border='0' alt='' /></a></iframe></body></html>" ];

if(randomNumber > -1){
  return null;
}
return ads_iframe[0];
  }
}
