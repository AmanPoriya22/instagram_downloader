
import 'dart:developer' as developer;

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:instagram_videos_downloader/pages/tabs/BrowserTab.dart';
import 'package:instagram_videos_downloader/pages/tabs/DownloadsTab.dart';
import 'package:instagram_videos_downloader/pages/tabs/HomeTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../common/MyBannerAd.dart';
import '../widget/MyWidget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.pageIndex}); // used to display add in whole app


  int pageIndex;

  static int countAd = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final cookieManager = WebviewCookieManager();
  final TextEditingController urlController = TextEditingController();
  late TabController _tabController;


  bool isLogin = false;

  //late BannerAd bannerAd;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: myTabs.length,initialIndex: widget.pageIndex);

    super.initState();

    //bannerAd = MyBannerAd().bannerAd(AdSize.fullBanner);
    userIsLogIn();
    addSpData();
  }

  Future addSpData() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool('showInformationScreen', false);
  }

  Future userIsLogIn() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if(prefs.getBool('isLogin') != null) {
        isLogin = prefs.getBool('isLogin')!;
      }
      developer.log('isLogin : $isLogin');
    });
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: "HOME"),
    const Tab(text: "BROWSER"),
    const Tab(text: "Downloads"),
  ];

  homeTabOnTap() {
    setState(() {
      _tabController.index = 0;
      Navigator.pop(context);
    });
  }
  browserTabOnTap() {
    setState(() {
      _tabController.index = 1;
      Navigator.pop(context);
    });
  }
  downloadsTabOnTap() {
    setState(() {
      _tabController.index = 2;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[Color(0xFFF79458),Color(0xFF936BD6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
          ),
          title: const Text('Video Downloader'),
          foregroundColor: Colors.white,
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              width: 35,
              height: 35,
              child: InkWell(
                onTap: () async {
                  openInstagramApp();
                },
                child: Image.asset(
                  'assets/images/instagram_white.png',
                  fit: BoxFit.contain,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ],
        ),
        drawer: myDrawer(context, isLogin, homeTabOnTap, browserTabOnTap, downloadsTabOnTap,_tabController),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: const [
                    Expanded(
                      child: SingleChildScrollView(
                        child: HomeTab(),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: BrowserTab(isLogin),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: DownloadsTab(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF79458), Color(0xFF936BD6)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            stops: [0.0, 0.8],
            tileMode: TileMode.clamp,
          ),
        ),
        child: CurvedNavigationBar(
          index: _tabController.index,
          buttonBackgroundColor: Color(0xFF936BD6),
          backgroundColor: Colors.white,
          items: <Widget>[
            const Icon(Icons.home, size: 30, color: Colors.white),
            Image.asset('assets/images/browser1.png', width: 30, height: 30),
            const Icon(Icons.download, size: 30, color: Colors.white),
          ],
          color: Color(0xFFF79458),
          onTap: (index) {
            print(index);
            setState((){
              _tabController.index = index;
            });

          },
        ),
      ),

        // Container(
        //   alignment: Alignment.center,
        //   width: bannerAd.size.width.toDouble(),
        //   height: bannerAd.size.height.toDouble(),
        //   child: AdWidget(
        //     ad: bannerAd,
        //   ),
        // )
    );
  }
}
