import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/T.dart';
import '../../../utils/progress_bar.dart';
import '../../../app/api.dart';
import '../../../app/shared_prefrence.dart';
import '../../../model/user_model.dart' show User;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:krushapp/app/api_dio.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class VerificationPage extends StatefulWidget {
  String phoneNumber;

  VerificationPage(this.phoneNumber);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  Function wp;
  String _message = '';
  Timer _timer;
  String currentCode;
  String currentCodeState = "";
  bool isCodeSent = true;
  final ValueNotifier<int> _counter = ValueNotifier<int>(120);
  BuildContext _context;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  String smsCode;
  String verificationId;

  @override
  void initState() {
    verifyPhone();
    super.initState();

    //  _Login();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }

    _counter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;

    return Scaffold(
      body: Stack(
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
            child: Container(
              child: ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 70 - MediaQuery.of(context).viewPadding.top),
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_outlined),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child:
                              SvgPicture.asset('assets/svg/krushin_logo.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 18),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OTP Authentication",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Text(
                          "An authentication code has been \nsent to ${widget.phoneNumber}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _myRowTextField(),
                  _mTextCounter(),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 17),
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
                          // _signInWithPhoneNumber(currentCode);
                          final AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                            verificationId: verificationId,
                            smsCode: currentCode,
                          );
                          signIn(credential);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23)),
                        child: Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _myRowTextField() {
    return Container(
        margin: EdgeInsets.only(top: 36),
        color: Colors.transparent,
        child: PinCodeTextField(
          length: 6,
          obsecureText: false,
          animationType: AnimationType.fade,
          fieldHeight: 55,
          fieldWidth: 48,
          enableActiveFill: true,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedColor: Colors.white,
          shape: PinCodeFieldShape.box,
          animationDuration: Duration(milliseconds: 300),
          textInputType: TextInputType.number,
          backgroundColor: Colors.transparent,
          borderWidth: 0.0,
          borderRadius: BorderRadius.circular(12),
          onChanged: (value) {
            currentCode = value;
          },
        ));
  }

  _mTextCounter() {
    return ValueListenableBuilder(
      builder: (BuildContext context, int value, Widget child) {
        return _mRowCounter(value);
      },
      valueListenable: _counter,
    );
  }

  _mRowCounter(int value) {
    if (isCodeSent) {
      return Container(
        margin: EdgeInsets.only(top: 23),
        alignment: Alignment.center,
        child: Text(
          value <= 0 ? "" : "${value}s",
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      );
    } else {
      return Container();
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_counter.value < 1) {
            timer.cancel();
            _counter.value = 120;
            verifyPhone();
          } else {
            _counter.value = _counter.value - 1;
          }
        },
      ),
    );
  }

  signIn(AuthCredential credential) async {
    ProgressBar.client.showProgressBar(context);
    try {
      final AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (result != null) {
        final FirebaseUser currentUser = await _auth.currentUser();
        if (result.user.uid == currentUser.uid) {
          UserSettingsManager.setUserID(result.user.uid);

          currentCodeState = "Code matched...";
          // _counter.value = -6;
          String fcmToken = "test";
          await _fcm.getToken().then((value) => fcmToken = value);
          String platformType;
          if (Platform.isAndroid) {
            platformType = "android";
          } else if (Platform.isIOS) {
            platformType = "ios";
          } else {
            platformType = "unknown";
          }

          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          user.getIdToken().then((result) {
            String token = result.token;
            ApiClient.apiClient
                .loginAction(userPhoneNumber:  widget.phoneNumber)
                .then((value) {
              ProgressBar.client.dismissProgressBar();
              if (value.status != true) {
                T.message("Something went wrong. Please try again");
              } else {
                 UserSettingsManager.setUserToken(
                        value.data.user.accessToken ?? null);
                        
                if (value.data.user.stripeCustomerId == null) {
                  ApiClient.apiClient
                      .getStripeId(
                          widget.phoneNumber)
                      .then((value) {
                    UserSettingsManager.setStripeId(value);
                  });
                } else {
                  UserSettingsManager.setStripeId(
                      value.data.user.stripeCustomerId);
                }

                if (value.status) {
                  if (value.data.user.isNewUser == 1) {
                    _timer.cancel();
                    _counter.dispose();
                    UserSettingsManager.setuserCoins(
                        value.data.user.coins ?? 0);
                    UserSettingsManager.setUserPhone(
                        value.data.user.mobileNumber ?? null);
                    UserSettingsManager.setsubscriptionShownStatus(1);
                    UserSettingsManager.setSubsciptionStatus(
                        value.data.user.isSubscribed);
                    UserSettingsManager.setSubscriptionTransactionID(
                        value.data.user.transactionId);
                    UserSettingsManager.setSubscriptionExpiryDate(
                        value.data.user.transactionDate);
                    UserSettingsManager.setUserContactsUpdateDate(
                        value.data.user.userContactsUpdateDate);
                    if (value.data.user.pending_requests > 0 &&
                        value.data.user.requestReceived != null) {
                      Navigator.pushNamed(context, '/AcceptKrushScreen',
                          arguments: value.data.user.requestReceived);
                    } else {
                      Navigator.pushNamed(context, '/KrushPhonePage',
                          arguments: value.data.user.pending_requests > 0);
                    }
                  } else {
                    setSession(value.data.user);
                  }
                }
              }
            });
          });
        } else {
          print(
              'signed in with phone number successful: user -> id is not same');
          ProgressBar.client.dismissProgressBar();
        }
      }
    } catch (e) {
      ProgressBar.client.dismissProgressBar();
      currentCodeState = "Verification code is wrong please try again.";
      // _counter.value = -7;
      sendOtpError(currentCodeState);
    }
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      startTimer();

      T.message("Verification code sent to " + widget.phoneNumber);
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) async {
      signIn(credential);
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      sendOtpError(exception.message);
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verifiedSuccess,
          verificationFailed: veriFailed);
    } catch (e) {
      sendOtpError(e);
    }
  }

  sendOtpError(String e) {
    T.message(e);
    Navigator.of(context).pop();
  }

  setSession(User user) async {
    if (_timer != null) {
      _timer.cancel();
    }

    if (_counter != null) {
      _counter.dispose();
    }

    if (user.stripeCustomerId == null) {
    } else {
      UserSettingsManager.setStripeId(user.stripeCustomerId);
    }

    UserSettingsManager.setUserID(user.userId.toString());
    UserSettingsManager.setUserName(user.displayName ?? null);
    UserSettingsManager.setEmail(user.email ?? null);
    UserSettingsManager.setUserImage(user.profilePic ?? null);
    UserSettingsManager.setUserToken(user.accessToken ?? null);
    UserSettingsManager.setUserPhone(user.mobileNumber ?? null);
    UserSettingsManager.setUserGender(user.gender ?? null);
    UserSettingsManager.setUserDOB(user.dateOfBirth.toString() ?? null);
    UserSettingsManager.setuserCoins(user.coins ?? null);
    UserSettingsManager.setFreeAcceptRequestsAllowed(user.freeAcceptsAvailable);
    UserSettingsManager.setFreesendRequestssAllowed(
        user.freeSendRequestAvailable);
    UserSettingsManager.setKrushToggle(user.enableNewKrushNotification);
    UserSettingsManager.setMessageToggle(user.enableNewChatMessageNotification);
    UserSettingsManager.setProfanityFilterToggle(user.profanityFilter);
    UserSettingsManager.setFreeAdsViewed(user.freeAdsViewed);
    UserSettingsManager.setSigninStatus(true);
    UserSettingsManager.setsubscriptionShownStatus(1);
    UserSettingsManager.setSubsciptionStatus(user.isSubscribed);
    UserSettingsManager.setSubscriptionTransactionID(user.transactionId);
    UserSettingsManager.setSubscriptionExpiryDate(user.transactionDate);
    UserSettingsManager.setUserContactsUpdateDate(user.userContactsUpdateDate);
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/MainScreen', (Route<dynamic> route) => false);
    // Navigator.of(context).pop();
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => MainScreen()));
  }

  Future<void> _Login() async {
    //  wp = Screen(MediaQuery.of(context).size).wp;
    //  _loading_info.show();
    String fcmToken = await _fcm.getToken();
    String platformType;
    if (Platform.isAndroid) {
      platformType = "android";
    } else if (Platform.isIOS) {
      platformType = "ios";
    } else {
      platformType = "unknown";
    }
    ApiClient.apiClient
        .loginAction(userPhoneNumber: widget.phoneNumber)
        .then((value) async {
      //  _loading_info.hide();
      if (value.status) {
        if (value.data.user.stripeCustomerId == null) {
          ApiClient.apiClient
              .getStripeId(widget.phoneNumber)
              .then((value) {
            UserSettingsManager.setStripeId(value);
          });
        } else {
          UserSettingsManager.setStripeId(value.data.user.stripeCustomerId);
        }

        if (value.data.user.isNewUser == 1) {
          UserSettingsManager.setUserToken(value.data.user.accessToken ?? null);
          UserSettingsManager.setuserCoins(value.data.user.coins ?? 0);
          UserSettingsManager.setUserPhone(
              value.data.user.mobileNumber ?? null);
          UserSettingsManager.setsubscriptionShownStatus(1);
          UserSettingsManager.setSubsciptionStatus(
              value.data.user.isSubscribed);
          UserSettingsManager.setSubscriptionExpiryDate(
              value.data.user.transactionDate);
          UserSettingsManager.setUserContactsUpdateDate(
              value.data.user.userContactsUpdateDate);
          if (value.data.user.pending_requests > 0) {
            Navigator.pushNamed(context, '/AcceptKrushScreen',
                arguments: value.data.user.requestReceived);
          } else {
            Navigator.pushNamed(context, '/KrushPhonePage',
                arguments: value.data.user.pending_requests > 0);
          }
          //  Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) =>
          //               KrushPhonePage(value.data.user.pending_requests>0)));
        } else {
          setSession(value.data.user);
        }
      }
    });
  }
}
