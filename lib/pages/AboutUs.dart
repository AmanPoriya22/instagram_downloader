import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://play.google.com/store/apps/details?id=com.nextinn.savelocation&hl=en_IN&gl=US',
          // onWebViewCreated: (WebViewController webViewController) {
          //   _controller = webViewController;
          //   _loadHtmlFromAssets();
          // },
        ),
      ),
    );
  }
}
