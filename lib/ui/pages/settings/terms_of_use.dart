import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/shapes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Terms Of Use")
      ),
      body: WebView(
        initialUrl: 'https://krushin.io/terms-of-use/',
        javascriptMode: JavascriptMode.unrestricted,
        
      ) 
    );
  }
}


