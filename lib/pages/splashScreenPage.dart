import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_videos_downloader/pages/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  Timer(const Duration(seconds: 2), () {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  HomePage(pageIndex: 0,)));
  }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text("Powered by:", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("NextInn Technology"),
            SizedBox(height: 40,)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Center(
          child: SizedBox(
            height: 80,
            width: 80,
            child: Image.asset("assets/images/insta_logo.png"),
          ),
        ),
      ),
    );
  }
}
