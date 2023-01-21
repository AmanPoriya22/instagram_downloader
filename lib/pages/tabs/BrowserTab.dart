
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserTab extends StatefulWidget {
  BrowserTab(this.isLogin, {Key? key}) : super(key: key);

  bool? isLogin;

  @override
  State<BrowserTab> createState() => _BrowserTabState();
}

class _BrowserTabState extends State<BrowserTab> with AutomaticKeepAliveClientMixin<BrowserTab>{

  Future addSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLogin', true);
    log('done');
  }

  @override
  void initState() {
    // TODO: implement initState

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.isLogin == true ? 'https://www.instagram.com/' : 'https://www.instagram.com/accounts/login/',
        navigationDelegate: (navigation) {
          if (!navigation.url.contains("https://www.instagram.com/accounts/login/")) {
            print('one');
            addSharedPreferences();
            return NavigationDecision.prevent;
          } else {
            print('two');
            return NavigationDecision.navigate;
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool wantKeepAlive = true;

}
