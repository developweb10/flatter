import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/shapes.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<Panel> panels = [
    Panel(
        'What is Krushin?',
        'Krushin is an app that allows you to anonymously connect with your krush. What you do with the opportunity, to chat without fear of recognition, is up to you.',
        false),
    Panel(
        'Is it REALLY anonymous?',
        "Uuuhh yes... that's kind of the point of this app. When you sign up we encrypt your personal info. Our lips are sealed.",
        false),
    Panel(
        "What is the reveal portion all about?",
        "Here is how it works. When you are ready to take the next step, Hit the Reveal button in the chat window. This allows your krush to see the real you.. ie your name, picture, and contact info.",
        false),
    Panel(
        'How do I know I am not being catfished?',
        "We have thought long and hard about this. If you have received a request from a Krush user, rest assured that person went through our verification process. Their identity is tied to the phone number they signed up with. But just to be on the safe side we never recommend meeting with anyone in person unless they have been revealed.",
        false),
    
  ];

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
                            "FAQ's",
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
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView(
            children: <Widget>[
              
              ...panels
                  .map((panel) => ExpansionTile(
                          title: Text(
                            panel.title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]),
                          ),
                          children: [
                            Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                   color: Color(0xffFAF1E2),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
                                ),
                               
                                child: Text(panel.content,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16)))
                          ]))
                  .toList(),
            ],
          ),
        ),)
        ) 
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}
