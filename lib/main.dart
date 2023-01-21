import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instagram_videos_downloader/pages/HomePage.dart';
import 'package:instagram_videos_downloader/pages/plashScreenPage.dart';
import 'package:instagram_videos_downloader/pages/splashScreenPage.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insta Downloader',
      theme: ThemeData(
        primarySwatch: Colors.red,//#F79458 //#936BD6 //#BA94CF
      ),
      home: const Scaffold(
        // body: PlashScreenPage()
        body: SplashScreen()
        // EasySplashScreen(
        //   logo: Image.asset('assets/images/appLogo.png'),
        //   backgroundColor: Colors.redAccent,
        //   showLoader: true,
        //   loadingText: const Text("Loading..."),
        //   navigator: const HomePage(),
        //   durationInSeconds: 5,
        // ),
      ),
    );
  }
}
