import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krushapp/ui/pages/settings/privacy_policy.dart';
import 'package:krushapp/ui/pages/settings/terms_of_use.dart';
import '../../../repositories/number_format_repository.dart';
import '../../../utils/T.dart';
import '../../../utils/shapes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Function wp;
  String selectedCountryCode = "+1";

  TextEditingController controller = new TextEditingController();
  NumberFormatRepository numberFormatRepository = NumberFormatRepository();

  bool privacytermsSelected = false;

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top,
                bottom: MediaQuery.of(context).viewPadding.bottom),
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 70 - MediaQuery.of(context).viewPadding.top),
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset('assets/svg/krushin_logo.svg'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(wp(4)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Enter Phone Number",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Text(
                        "Enter your phone number to \nverify yourself",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                //mHeight(wp(4)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 17),
                  child: Container(
                    // width: double.infinity,
                    // height: wp(40),
                    child: Card(
                      margin: EdgeInsets.only(top: 18),
                      elevation: 4,
                      shape: cardShape(10.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Phone Number',
                                style: TextStyle(color: Color(0xFF8F92A1)),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  _buildCountryCodePicker(),
                                  Expanded(
                                    child: TextField(
                                      maxLength: 10,
                                      buildCounter: (context,
                                          {currentLength,
                                          isFocused,
                                          maxLength}) {
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      controller: controller,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: "Enter Your Phone Number",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      //controller: email,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Checkbox(
                            value: privacytermsSelected,
                            activeColor: Colors.white,
                            hoverColor: Colors.white,
                            checkColor: Colors.red,
                            onChanged: (bool value) {
                              setState(() {
                                privacytermsSelected = !privacytermsSelected;
                              });
                            }),
                      ),

                      SizedBox(width: 5),

                      Expanded(
                        child: Center(
                            child: AutoSizeText.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "I agree to krushin  ",
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => PrivacyPolicy()));
                                  }),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => TermsOfUse()));
                                  })
                          ]),
                          style: TextStyle(fontSize: 20),
                          maxLines: 1,
                        )),
                      )

                      //    RichText(
                      //     text: TextSpan(children: [

                      // ])),
                    ]),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               mainAxisSize: MainAxisSize.min,
                //               children:[
                //                         Theme(
                //   data: Theme.of(context).copyWith(
                //     unselectedWidgetColor: Colors.white,
                //   ),
                //   child: Checkbox(value: termsSelected, activeColor: Colors.white, checkColor: Colors.red, onChanged: (bool value){
                //              setState(() {
                //                termsSelected = !termsSelected;
                //              });
                //            }),
                // ),

                //            SizedBox(
                //              width: 10
                //            ),

                //            RichText(
                //             text: TextSpan(children: [
                //           TextSpan(text: "I agree to  ", style: TextStyle(color: Colors.white, fontSize: 17)),
                //          TextSpan(
                //                   text: 'Krushin terms & conditions',
                //                   style: TextStyle(color: Colors.white, decoration: TextDecoration.underline, fontSize: 17),
                //                   recognizer: TapGestureRecognizer()
                //                     ..onTap = () {
                //                                                  Navigator.of(context).push(
                //                             MaterialPageRoute(
                //                                 builder: (_) =>
                //                                     TermsOfUse()));
                //                     })

                //         ])),
                //             ]
                //             ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
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
                        String formattedNumber = numberFormatRepository
                            .changeNumber(controller.text);
                        if (formattedNumber.length != 10) {
                          T.message("Please enter valid Mobile Number.");
                        } else {
                          if (!privacytermsSelected) {
                            T.message(
                                "Please agree to Krushin Privacy Policy and Terms");
                          } else {
                            Navigator.pushNamed(context, '/VerificationPage',
                                arguments:
                                    selectedCountryCode + formattedNumber);
                          }

                          // navigateTo(
                          //     context,
                          //     VerificationPage(
                          //       selectedCountryCode + formattedNumber));

                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                      child: Text(
                        'Get OTP',
                        style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCodePicker() {
    return CountryCodePicker(
      initialSelection: 'US',
      favorite: ['+1', 'US'],
      showCountryOnly: true,
      showFlag: true,
      showOnlyCountryWhenClosed: false,
      onChanged: (value) {
        selectedCountryCode = value.toString();
      },
    );
  }
}
