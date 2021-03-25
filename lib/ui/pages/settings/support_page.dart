import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:krushapp/app/api.dart';
import '../../../app/shared_prefrence.dart';
import '../../../model/result.dart';
import '../../../utils/Constants.dart';
import '../../../utils/T.dart';
import '../../../utils/progress_bar.dart';
import '../../../utils/shapes.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
int subjectSelected = -1;
TextEditingController emailController = TextEditingController();
TextEditingController subjectController = TextEditingController();
TextEditingController descController = TextEditingController();

Future<Result> sendEmail() async {

    String token = await UserSettingsManager.getUserToken();
    Map<String, String> jsonMap = {
      "email": emailController.text,
      "subject": subjectController.text,
      "description": descController.text
    };

    Map<String, String> headers = {"Authorization": "bearer " + token};

    try {
      final response = await Constants.httpClient.post(
          "${ApiClient.apiClient.baseUrl}/support_mail",
          body: jsonMap,
          headers: headers);
      final parsed = json.decode(response.body);
      Result result = Result.fromJson(parsed);
      return result;
    } on SocketException {
      return Future.error("check your internet connection");
    } on ClientException {
      return Future.error("check your internet connection");
    } catch (e) {
      return Future.error("Server Error");
    }
  

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
                            "Help & Support",
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
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10), 
          child: ListView(
            children: <Widget>[
                   SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        textCapitalization: TextCapitalization.words,
                                        controller: emailController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Your Email",
     enabledBorder: const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
    ),
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.redAccent.withOpacity(0.1),
                          // border:
                          //     Border.all(color: Theme.of(context).accentColor)
                              ),
                      // height: 50,
                    ),
                  ],
                ),

                                   SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.words,
                                        controller: subjectController,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5), //Change this value to custom as you like
    isDense: true,
     labelText: "Enter subject", // and add this line
   ),

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.redAccent.withOpacity(0.1),
                          // border:
                          //     Border.all(color: Theme.of(context).accentColor)
                              ),
                      // height: 50,
                    ),
                  ],
                ),

                          SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(0),
                      child: Row(children: [
                        Radio(value: 0, groupValue: subjectSelected, onChanged: (value) {
                          setState(() {
                          subjectSelected = value;
                          subjectController.text = "Technical Issue";
                        });

                      }, ),

                      Text("Technical Issue")

                      ],) 

                      
                      // height: 50,
                    ),

                    Flexible(child: 
                    
                    Container(
                      padding: EdgeInsets.all(0),
                      child: Row(children: [
                        Radio(value: 1, groupValue: subjectSelected, onChanged: (value) {
                          setState(() {
                          subjectSelected = value;
                           subjectController.text = "Bug Report";
                        });
                      }, ),

                      Text("Bug Report")

                      ],) 

                      
                      // height: 50,
                    ),)
                  ],
                ),

                          SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(0),
                      child: Row(children: [
                        Radio(value: 2, groupValue: subjectSelected, onChanged: (value) {
                          setState(() {
                          subjectSelected = value;
                          subjectController.text = "Payment Issue";
                        });
                      }, ),

                      Text("Payment Issue")

                      ],) 

                      
                      // height: 50,
                    ),

                    Flexible(child: 
                    
                    Container(
                      padding: EdgeInsets.all(0),
                      child: Row(children: [
                        Radio(value: 3, groupValue: subjectSelected, onChanged: (value) {
                        setState(() {
                          subjectSelected = value;
                            subjectController.text = "Feedback";
                        });
                      }, ),

                      Text("Feedback")

                      ],) 

                      
                      // height: 50,
                    ),)
                  ],
                ),

                          SizedBox(height: 15),

                                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                       height: MediaQuery.of(context).size.height * 0.25,
                      padding: EdgeInsets.all(5),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Container(
                              // height: 30,
                              child: TextField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: descController,
                                        textAlign: TextAlign.start,
                                        textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical:5),
     labelText: "Describe your issue...", 
   ),

  //  maxLines: 5,

                                        //controller: email,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                            )
                          ]),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.redAccent.withOpacity(0.1),
                          // border:
                          //     Border.all(color: Theme.of(context).accentColor)
                              ),
                      // height: 50,
                    ),
                  ],
                ),

                  SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  RaisedButton(
        onPressed: () async {
          ProgressBar.client.showProgressBar(context);
          Result result = await sendEmail();
          if(result.status == true){
            ProgressBar.client.dismissProgressBar();
            T.message("Email sent successfully");
            Navigator.of(context).pop();
          }else{
            ProgressBar.client.dismissProgressBar();
            T.message(result.message);
          }
        },
        padding: EdgeInsets.symmetric(horizontal: 66, vertical: 14),
        color: Theme.of(context).accentColor,
        
        shape: StadiumBorder(),
        child: Text("Send",style: TextStyle(color:Colors.white ),),
      ),
                ],)
         
            ],
          ),
        ),)
        ) 
      ),
    );
  }
}
