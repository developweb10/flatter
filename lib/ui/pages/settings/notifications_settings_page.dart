import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/utils/progress_bar.dart';
import 'package:krushapp/utils/shapes.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool freeGifts = true;
  bool krushNotification = false;
  bool messageNotifications = false;
  String token = "";
  bool _loading = false;

  getToken() {
    UserSettingsManager.getUserToken().then((t) {
      setState(() {
        token = t;
      });
    });
  }

  getNotifcationStatus() async {
    await UserSettingsManager.getMessageToggle().then((t) {
      setState(() {
        messageNotifications = t == 1 ? true : false;
      });
    });

    await UserSettingsManager.getKrushToggle().then((t) {
      setState(() {
        krushNotification = t == 1 ? true : false;
      });
    });
  }

  onChanged(String type, bool status) {
    ProgressBar.client.showProgressBar(context);

    if (type == "message") {
      ApiClient.apiClient
          .notificationToggle("toggle_chat_notification", status)
          .then((value) {
        ProgressBar.client.dismissProgressBar();
        if (value['status']) {
          UserSettingsManager.setMessageToggle(
              value['data']['user']['enableNewChatMessageNotification']);
          getNotifcationStatus();
        } else {
          // T.message("Coins adding failed");
        }
      });
    } else if (type == "krush") {
      ApiClient.apiClient
          .notificationToggle( "toggle_krush_notification", status)
          .then((value) {
        ProgressBar.client.dismissProgressBar();

        if (value['status']) {
          UserSettingsManager.setKrushToggle(
              value['data']['user']['enableNewKrushNotification']);
          getNotifcationStatus();
        } else {
          // T.message("Coins adding failed");
        }
      });
    } else {
          ProgressBar.client.dismissProgressBar();
    }
  }

  Widget platformSwitch_message(bool val) {
      return CupertinoSwitch(
        onChanged: (value) async {
          await onChanged("message", value);
        },
        value: val,
        activeColor: Colors.green,
      );
  }

  Widget platformSwitch_krush(bool val) {
      return CupertinoSwitch(
        onChanged: (value) async {
          await onChanged("krush", value);
        },
        value: val,
        activeColor: Colors.green,
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    getNotifcationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            Icons.arrow_back_ios,
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
                            "Notifications",
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
      body: SafeArea(
        bottom: true,
        child: Container(
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
          child:  Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 16.0),
              //   child: Text(
              //     'Notifications',
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 25.0),
              //   ),
              // ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    // ListTile(
                    //   title: Text(
                    //     'Gifts',
                    //     style: TextStyle(fontSize: 20.0),
                    //   ),
                    //   trailing: platformSwitch((value){
                    //     setState(() {
                    //       myOrders = value;
                    //     });
                    //   },myOrders),
                    // ),
                    ListTile(
                      title: Text(
                        'New Krush Requests',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      trailing: platformSwitch_krush(krushNotification),
                    ),
                    ListTile(
                      title: Text(
                        'New Chat Message',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      trailing: platformSwitch_message(messageNotifications),
                    ),
                    /* ListTile(
                      title: Text('Feedbacks and Reviews',
                    style: TextStyle(
                          fontSize: 20.0),),
                      trailing: platformSwitch(feedbackReviews,)
                    ),
                    ListTile(
                      title: Text('Updates',
                    style: TextStyle(
                          fontSize: 20.0),),
                      trailing: platformSwitch(updates),
                    ), */
                  ],
                ),
              ),
            ],
          ),
        ),
          )
      ),
      )
    );
  }
}
