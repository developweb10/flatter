import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/app/api.dart';
import 'package:krushapp/app/shared_prefrence.dart';
import 'package:krushapp/model/chat_conversation_model.dart';
import 'package:krushapp/ui/dialogs/confirm_reveal_dialog.dart';
import 'package:krushapp/ui/pages/krush_reveal_page.dart';
import 'package:krushapp/ui/pages/reveal_info/reveal_info_page.dart';
import 'package:krushapp/utils/progress_bar.dart';

class ChatOptionsScreen extends StatefulWidget {
  final ChatsConversationModel requestData;
  ChatOptionsScreen(this.requestData);
  @override
  _ChatOptionsScreenState createState() => _ChatOptionsScreenState();
}

class _ChatOptionsScreenState extends State<ChatOptionsScreen> {
  String token;
  bool infoRevealed = false;
  bool blocked = false;
  

  @override
  void initState() {
    UserSettingsManager.getUserToken().then((value) {
      token = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Chat Settings'),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.only(top: 12, left: 12),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Block',
                      style: TextStyle(
                          fontSize: 24, color: Theme.of(context).primaryColor),
                    ),
                    CupertinoSwitch(
                        activeColor: Theme.of(context).primaryColor,
                        value: blocked,
                        onChanged: (value) async {
                          ProgressBar.client.showProgressBar(context);
                          await ApiClient.apiClient.blockKrush(
                              widget.requestData.relationId.toString());
                          ProgressBar.client.dismissProgressBar();
                          setState(() {
                            this.blocked = value;
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                reveal()
              ],
            ),
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14))),
          )
        ],
      ),
    );
  }

  reveal() {
    if (widget.requestData.sentRequest) {
      //senders screen
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reveal Info',
            style:
                TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
          ),
          CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              value: widget.requestData.hasRevealed,
              onChanged: (value) {
                if (!widget.requestData.hasRevealed) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Reveal Info?',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Your Krush will know who you are',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          'No',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.red,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          'Yes, Reveal',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Color(0xFF4CD964),
                                        onPressed: () async {
                                          Navigator.of(context).pop();

                                          try {
                                            ProgressBar.client
                                                .showProgressBar(context);
                                            await ApiClient.apiClient
                                                .revealKrush(
                                                 
                                                    widget
                                                        .requestData.relationId
                                                        .toString());
                                            setState(() {
                                              widget.requestData.hasRevealed =
                                                  true;
                                            });
                                          } catch (e) {
                                          }
                                          ProgressBar.client
                                              .dismissProgressBar();
                                        }),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              })
        ],
      );
    } else {
      if (widget.requestData.hasRevealed)
        return ListTile(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => KrushRevealPage({
                  'relationId':widget.requestData.relationId.toString(),
                  'token':token
                })));
          },
          title: Text(
            'Show Revealed Info',
            style:
                TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
          ),
        );
      else
        return Offstage();
    }
  }
}
