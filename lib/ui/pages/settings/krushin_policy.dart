import 'dart:io';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/shapes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KrushinPolicy extends StatefulWidget {
  @override
  _KrushinPolicyState createState() => _KrushinPolicyState();
}

class _KrushinPolicyState extends State<KrushinPolicy> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Privacy Policy")
      ),
      body: WebView(
        initialUrl: 'https://krushin.io/krushin-guidelines/',
        javascriptMode: JavascriptMode.unrestricted,
        
      ) 
    );
  }
}