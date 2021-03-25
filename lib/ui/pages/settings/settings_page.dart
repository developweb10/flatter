import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/utils/progress_bar.dart';
import '../../../utils/shapes.dart';

import 'block_contacts_screen.dart';
import 'faq_page.dart';
import 'gift_return_policy.dart';
import 'krushin_policy.dart';
import 'krushin_policy.dart';
import 'notifications_settings_page.dart';
import 'privacy_policy.dart';
import 'terms_of_use.dart';

//import 'change_language_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool profanityFilter = false;
  String token;

  @override
  void initState() {
    UserSettingsManager.getUserToken().then((t) {
      setState(() {
        token = t;
      });
    });
    UserSettingsManager.getProfanityFilterToggle().then((value) {
      setState(() {
        this.profanityFilter = value == 0 ? false : true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onTap: () {
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
                        ),
                      ),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Settings",
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
          child: SafeArea(
            bottom: true,
            child: LayoutBuilder(
                builder: (builder, constraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // ListTile(
                              //     title: Text(
                              //       'Block Numbers',
                              //       style: TextStyle(fontSize: 20.0),
                              //     ),

                              //     leading: Icon(Icons.block, color: Colors.black,),
                              //     trailing: Icon(Icons.arrow_forward_ios),
                              //     onTap: () => Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //             builder: (_) =>
                              //                 BlockContactsScreen())),
                              //   ),
                              //   SizedBox(
                              //     height: 10,
                              //   ),
                              ListTile(
                                title: Text(
                                  'Profanity Filter',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.text_fields,
                                  color: Colors.black,
                                ),
                                trailing: CupertinoSwitch(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: profanityFilter,
                                    onChanged: (value) async {
                                      ProgressBar.client
                                          .showProgressBar(context);

                                      await ApiClient.apiClient
                                          .toggleProfanityFilter(
                                               (value) ? 1 : 0);
                                      ProgressBar.client.dismissProgressBar();
                                      UserSettingsManager
                                          .setProfanityFilterToggle(
                                              (value) ? 1 : 0);
                                      setState(() {
                                        profanityFilter = value;
                                      });
                                    }),
                                onTap: () {},
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                title: Text(
                                  'Notifications',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            NotificationSettingsPage())),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                title: Text(
                                  "FAQ's",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.info_outline,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => FAQPage())),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              ListTile(
                                title: Text(
                                  'Terms Of Use',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.message,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => TermsOfUse())),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                title: Text(
                                  "Privacy Policy",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.verified_user,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => PrivacyPolicy())),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                title: Text(
                                  'Krushin Policies',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.lock_open,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => KrushinPolicy())),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                title: Text(
                                  'Gift Return Policy',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                leading: Icon(
                                  Icons.card_giftcard,
                                  color: Colors.black,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => GiftReturnPolicy())),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
