import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class UserSettingsManager {
  static String COOKIE = "cookie";
  static String USER_ID = "user.id";
  static String USER_NAME = "user.name";
  static String EMAIL = "user.email";
  static String USER_IMAGE = "user.image";
  static String USER_TOKEN = "user.token";
  static String USER_PHONE = "user.phone";
  static String USER_GENDER = "user.gender";
  static String USER_DOB = "user.dob";
  static String THEME_MODE = "darkMode";
  static String SLIDER = "slder";
  static String SIGNED_IN = "signed_in";
  static String COINS = "coins";
  static String STRIPEID = "stripeId";
  static String FREEACCEPTSAVAILABLE = "freeAcceptsAvailable";
  static String FREESENDREQUESTAVAILABLE = "freeSendRequestAvailabled";
  static String FREEADSALLOWED = "freeAdsAvailable";
  static String KRUSHTOGGLE = "krushToggle";
  static String MESSAGETOGGLE = "messageToggle";
  static String PROFANITYFILTERTOGGLE = "profanityFilterToggle";
  static String SUBSCRIPTIONSHOWN = "subscriptionShowCount";
  static String SUBSCRIPTIONSTATUS = "subscriptionStatus";
  static String SHOWONBOARDINGSCREENS = "showOnboardingscreens";
  static String SUBSCRIPTIONTRANSACTIONID = "subscriptiontransactionid";
  static String TRANSACTIONID = "transactionId";
  static String USERCONTACTSUPDATEDATA = "usercontactupdatedate";

  static String ENCRYPTIONKEY = "encryptionKey";

  static Future<Box> _userSettingsBox = Hive.openBox('userSettings');
  static Future<Box> _accessTokenEncryptedBox = _openEncryptedBox();

  static Future<Box<dynamic>> _openEncryptedBox() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: ENCRYPTIONKEY);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: ENCRYPTIONKEY, value: base64UrlEncode(key));
    }
    var encryptionKey =
        base64Url.decode(await secureStorage.read(key: ENCRYPTIONKEY));
    return Hive.openBox('accessTokenBox',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  static setCookie(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(COOKIE, cookie);
  }

  static Future<String> getCookie() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(COOKIE);
  }

  static setUserID(String id) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_ID, id);
  }

  static Future<String> getUserID() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_ID);
  }

  static setUserName(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_NAME, cookie);
  }

  static Future<String> getUserName() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_NAME);
  }

  static setEmail(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(EMAIL, cookie);
  }

  static Future<String> getEmail() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(EMAIL);
  }

  static setUserImage(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_IMAGE, cookie);
  }

  static Future<String> getUserImage() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_IMAGE);
  }

  static setUserToken(String cookie) async {
    
    Box accesTokenBox = await _accessTokenEncryptedBox;
    accesTokenBox.put(USER_TOKEN, cookie);
  }

  static Future<String> getUserToken() async {
    Box accesTokenBox = await _accessTokenEncryptedBox;
    return accesTokenBox.get(USER_TOKEN);
  }

  //phone
  static setUserPhone(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_PHONE, cookie);
  }

  static Future<String> getUserPhone() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_PHONE);
  }

  //Gender
  static setUserGender(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_GENDER, cookie);
  }

  static Future<String> getUserGender() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_GENDER);
  }

  //DOB
  static setUserDOB(String cookie) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USER_DOB, cookie);
  }

  static Future<String> getUserDOF() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USER_DOB);
  }

  static setThemeMod(bool res) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(THEME_MODE, res);
  }

  static Future<bool> getThemeMod() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(THEME_MODE) ?? false;
  }

  static setSliderStatus(bool res) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(SLIDER, res);
  }

  static Future<bool> isNeedSlider() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(SLIDER) ?? true;
  }

  static setSigninStatus(bool res) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(SIGNED_IN, res);
  }

  static Future<bool> getSigninStatus() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(SIGNED_IN) ?? false;
  }

  static setuserCoins(int coins) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(COINS, coins);
  }

  static Future<int> getuserCoins() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(COINS) ?? 0;
  }

  static setStripeId(String stripeId) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(STRIPEID, stripeId);
  }

  static Future<String> getStripeId() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(STRIPEID);
  }

  static setFreeAcceptRequestsAllowed(int freeAccept) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(FREEACCEPTSAVAILABLE, freeAccept);
  }

  static Future<int> getFreeAcceptRequestsAllowed() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(FREEACCEPTSAVAILABLE) ?? 0;
  }

  static setFreesendRequestssAllowed(int freeAccept) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(FREESENDREQUESTAVAILABLE, freeAccept);
  }

  static Future<int> getFreesendRequestssAllowed() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(FREESENDREQUESTAVAILABLE) ?? 0;
  }

  static setFreeAdsViewed(int freeAds) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(FREEADSALLOWED, freeAds);
  }

  static Future<int> getFreeAdsViewed() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(FREEADSALLOWED) ?? 0;
  }

  static setProfanityFilterToggle(int status) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(PROFANITYFILTERTOGGLE, status);
  }

  static setMessageToggle(int status) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(MESSAGETOGGLE, status);
  }

  static Future<int> getProfanityFilterToggle() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(PROFANITYFILTERTOGGLE, defaultValue: 0);
  }

  static Future<int> getMessageToggle() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(MESSAGETOGGLE) ?? 0;
  }

  static setKrushToggle(int status) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(KRUSHTOGGLE, status);
  }

  static Future<int> getKrushToggle() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(KRUSHTOGGLE) ?? 0;
  }

  static setsubscriptionShownStatus(int counter) async {
    if (counter == 2) {
      counter = 0;
    } else
      counter += 1;
    Box userSettings = await _userSettingsBox;
    userSettings.put(SUBSCRIPTIONSHOWN, counter);
  }

  static Future<int> getsubscriptionShownStatus() async {
    Box userSettings = await _userSettingsBox;

    return userSettings.get(SUBSCRIPTIONSHOWN) ?? false;
  }

  static setSubsciptionStatus(int status) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(SUBSCRIPTIONSTATUS, status);
  }

  static Future<int> getSubsciptionStatus() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(SUBSCRIPTIONSTATUS) ?? 0;
  }

  static setshowOnBoardingScreens(bool status) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(SHOWONBOARDINGSCREENS, status);
  }

  static Future<bool> getshowOnBoardingScreens() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(SHOWONBOARDINGSCREENS) ?? true;
  }

  static setSubscriptionTransactionID(String id) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(SUBSCRIPTIONTRANSACTIONID, id);
  }

  static Future<String> getSubscriptionTransactionID() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(SUBSCRIPTIONTRANSACTIONID);
  }

  static setSubscriptionExpiryDate(String dateTime) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(TRANSACTIONID, dateTime);
  }

  static Future<String> getSubscriptionExpiryDate() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(TRANSACTIONID);
  }

  static setUserContactsUpdateDate(String dateTime) async {
    Box userSettings = await _userSettingsBox;
    userSettings.put(USERCONTACTSUPDATEDATA, dateTime);
  }

  static Future<String> getUserContactsUpdateDate() async {
    Box userSettings = await _userSettingsBox;
    return userSettings.get(USERCONTACTSUPDATEDATA);
  }
}
