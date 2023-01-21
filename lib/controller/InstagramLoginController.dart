import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramLoginController extends StatefulWidget {
  const InstagramLoginController({Key? key}) : super(key: key);

  @override
  InstagramLoginControllerState createState() => InstagramLoginControllerState();
}

class InstagramLoginControllerState extends State<InstagramLoginController> {

  Future addSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', true);
    log('done');
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://www.instagram.com/accounts/login/',
        navigationDelegate: (navigation) {
          if (!navigation.url.contains("https://www.instagram.com/accounts/login/")) {
            Navigator.pop(context);
            addSharedPreferences();
            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
      ),
    );
  }
}
