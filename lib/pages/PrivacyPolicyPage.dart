import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPrivacyPolicyPage extends StatefulWidget {
  const MyPrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<MyPrivacyPolicyPage> createState() => _MyPrivacyPolicyPageState();
}

class _MyPrivacyPolicyPageState extends State<MyPrivacyPolicyPage> {
  WebViewController? _controller;

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/html/MyPrivacyPolicy.html');
    _controller!.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets();
            },
          ),
        ),
      ),
    );
  }
}
