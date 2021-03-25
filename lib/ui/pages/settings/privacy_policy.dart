import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/shapes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Privacy Policy")
      ),
      body: WebView(
        initialUrl: 'https://krushin.io/privacy-policy/',
        javascriptMode: JavascriptMode.unrestricted,
        
      ) 
    );
  }
}


