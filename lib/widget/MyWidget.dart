import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../pages/HomePage.dart';
import '../pages/PrivacyPolicyPage.dart';

Future<bool?> toast(String msg) {
  return Fluttertoast.showToast(
    msg: msg.toString(),
    fontSize: 15,
    backgroundColor: Colors.black45,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}

Future userIsLogout() async {
  final cookieManager = WebviewCookieManager();

  final prefs = await SharedPreferences.getInstance();
  prefs.remove('isLogin');

  // Checking for Cookies
  final gotCookies =
      await cookieManager.getCookies('https://www.instagram.com/');
  log(gotCookies.toString());

  gotCookies.forEach((element) async {
    log("All Cookies Is : ${element.domain}");

    cookieManager.clearCookies();
  });

  log('After remove Cookies $gotCookies');
}

void openInstagramApp() async {
  if (await launchUrl(Uri.parse("https://www.instagram.com/"),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ';
  }
}

void openYoutubeApp() async {
  if (await launchUrl(Uri.parse("https://www.youtube.com/"),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ';
  }
}

void openMorePage() async {
  if (await launchUrl(
      Uri.parse("https://play.google.com/store/search?q=pub%3ANext%20Inn%20Technology&c=apps"),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ';
  }
}

void openRatePage() async {
  if (await launchUrl(
      Uri.parse(
          "https://play.google.com/store/apps/details?id=com.nextinn.insta.videodownloader&hl=en_IN&gl=US"),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ';
  }
}

Future<List> getVideoDetails(String videoLink) async {
  List? data;
  final videoInfo = FlutterVideoInfo();

  var info = await videoInfo.getVideoInfo(videoLink);

  print('title : ${info!.title}');
  print('path : ${info.path}');
  print('duration : ${info.duration}');
  print('date : ${info.date}');
  print('mimetype : ${info.mimetype}');

  data!.add(info.title); // 0
  data.add(info.path); // 1
  data.add(info.duration); // 2
  data.add(info.date); // 3
  data.add(info.mimetype); // 4

  return data;
}

Future<void> deleteFile(BuildContext context, File file, String title) async {
  try {
    if (await file.exists()) {
      print('exist');

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: const [Icon(Icons.delete), Text("Delete")],
            ),
            content: Text('Do you want to delete $title?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomePage(
                              pageIndex: 2,
                            )));
                    await file.delete();
                    toast('${title.toString()} is deleted');
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'))
            ],
          );
        },
      );
    }
  } catch (e) {
    print('file Error : ${e.toString()}');
    // Error in getting access to the file.
  }
}

Widget myDrawer(
    BuildContext context,
    bool isLogin,
    GestureTapCallback? homeTabOnTap,
    GestureTapCallback? browserTabOnTap,
    GestureTapCallback? downloadsTabOnTap,
    TabController _tabController) {
  return Drawer(
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF79458), Color(0xFF936BD6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/insta_logo.png',
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Video Downloader",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Card(
                        color: _tabController.index == 0
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: homeTabOnTap,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.home,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 14),
                                Text("Home",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 1
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: browserTabOnTap,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.open_in_browser,
                                    size: 30, color: Colors.white),
                                // Image.asset('assets/images/browser.png', width: 30, height: 30,fit: BoxFit.fill),
                                SizedBox(width: 14),
                                Text("Browser",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 2
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: downloadsTabOnTap,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.download,
                                    size: 30, color: Colors.white),
                                SizedBox(width: 14),
                                Text(
                                  "Downloads",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 3
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            openMorePage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.more_horiz,
                                    size: 30, color: Colors.white),
                                SizedBox(width: 14),
                                Text(
                                  "More",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 4
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            WcFlutterShare.share(
                                sharePopupTitle: 'Share',
                                subject: 'Video Downloader',
                                text:
                                    'https://play.google.com/store/apps/details?id=instagram_videos_downloaderr',
                                mimeType: 'text/plain');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.share,
                                    size: 30, color: Colors.white),
                                SizedBox(width: 14),
                                Text(
                                  "Share",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 5
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyPrivacyPolicyPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.book_rounded,
                                    size: 30, color: Colors.white),
                                SizedBox(width: 14),
                                Text(
                                  "Privacy & Policy",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: _tabController.index == 6
                            ? const Color(0xFF936BD6)
                            : Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            openRatePage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: const [
                                Icon(Icons.rate_review,
                                    size: 30, color: Colors.white),
                                SizedBox(width: 14),
                                Text(
                                  "Rate Us",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLogin == true)
                        Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  pageIndex: 0,
                                                )));
                                    userIsLogout();
                                  },
                                  child: Row(
                                    children: const [
                                      Text("Logout"),
                                      SizedBox(width: 10),
                                      Icon(Icons.logout),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

handleClick(BuildContext context, String value, String path, String title) {
  switch (value) {
    case 'Share':
      ShareExtend.share('/$path', "video");
      break;
    case 'Delete':
      print('delete path : ${path}');
      deleteFile(context, File('/$path'), title.toString());
      break;
  }
}

unFocus(BuildContext context) {
  var currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
