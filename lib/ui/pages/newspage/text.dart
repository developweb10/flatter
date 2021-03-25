import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';


class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage>   {


  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0), // here the desired height
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

          )),
      // Set the TabBar view as the body of the Scaffold
      body:  Expanded(
        child: Text('Title:',
            style: TextStyle(
                fontSize:
                20.0,
                color: Colors
                    .white),
            textAlign:
            TextAlign
                .center),
      ),
      // Set the bottom navigation bar

    );

  }
}
