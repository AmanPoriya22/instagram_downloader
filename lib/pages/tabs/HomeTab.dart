import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:instagram_videos_downloader/pages/HomePage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/MyInterstitialAd.dart';
import '../../widget/MyWidget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController urlController = TextEditingController();
  final ReceivePort _port = ReceivePort();

  String? pasteValue;
  bool showProgress = false;
  int downloadingProgress = 0;

  var progress = 0;

  static int loadAd = 0;

  //late BannerAd bannerAd;

  @override
  void initState() {
    // TODO: implement initState

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      final taskId = (data[0]);
      final status = data[1];
      setState(() {
        progress = data[2];
        if (progress >= 100) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage(pageIndex: 2)));
        }
      });

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    super.initState();
    //bannerAd = MyBannerAd().bannerAd(AdSize.fullBanner);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Copy url link from app and paste here",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter URL';
                    } else {
                      if (!value.contains(RegExp(
                              r'^(?:https?:\/\/www\.)?instagram\.com\/(?:reel|p)\/(\w+)\/?'))
                          // && !value.contains(RegExp(r'^(?:https?:\/\/)?(?:www\.)?(mbasic.facebook|m\.facebook|facebook|fb)\.(com|me)\/(?:(?:\w\.)*#!\/)?(?:pages\/)?(?:[\w\-\.]*\/)*([\w\-\.]*)'))
                          &&
                          !value.contains(RegExp(
                              r'^((https?://)?(www\.)?twitter\.com/)?(@|#!/)?([A-Za-z0-9_]{1,15})(/([-a-z]{1,20}))?')) &&
                          !value.contains(RegExp(
                              r'^^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$'))) {
                        return 'Enter \'Instagram\', \'YouTube\' or \'Twitter\' URL';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      urlController.text = value.toString();
                      print("PPPPP ${value}");
                    });
                  },
                  controller: urlController,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            loadAd = (loadAd + 1);
                            log('UUUUU :: $loadAd');
                            if (loadAd == 5) {
                              loadAd = 0;
                              MyInterstitialAd.loadInterstitialAd(
                                  context, File(''), 'Home');
                              urlController.text = '';
                            } else {
                              urlController.text = '';
                            }
                          });
                        },
                        child: const Icon(Icons.clear, color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Past your link here'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 45,
                  width: 160,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [Color(0xFFF79458), Color(0xFF936BD6)],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      stops: [0.0, 0.8],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      FlutterClipboard.paste().then((value) {
                        // Do what ever you want with the value.
                        setState(() {
                          loadAd = (loadAd + 1);
                          log('UUUUU :: $loadAd');
                          if (loadAd == 5) {
                            loadAd = 0;
                            MyInterstitialAd.loadInterstitialAd(
                                context, File(''), 'Home');
                            if (urlController.text.isEmpty) {
                              pasteValue = value;
                              urlController.text = value.toString();
                              log("MMMMMMMM : ${value.toString()}");
                            } else {
                              log("Clear Entered text first");
                              toast('Clear Text To Past Link');
                            }
                          } else {
                            if (urlController.text.isEmpty) {
                              pasteValue = value;
                              urlController.text = value.toString();
                              log("MMMMMMMM : ${value.toString()}");
                            } else {
                              log("Clear Entered text first");
                            }
                          }
                        });
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Paste Link',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  width: 160,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [Color(0xFFF79458), Color(0xFF936BD6)],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      stops: [0.0, 0.8],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      final status = await Permission.storage.request();
                      if (progress != 0) progress == 0;

                      if (_formKey.currentState!.validate()) {
                        if (status.isGranted) {
                          loadAd = (loadAd + 1);
                          log('UUUUU :: $loadAd');

                          showProgress = true;

                          if(showProgress) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );
                          }

                          // if (loadAd == 5) {
                          //   loadAd = 0;
                          //   MyInterstitialAd.loadInterstitialAd(
                          //       context, File(''), 'Home');
                          // } else {
                          //   CheckUserLink().checkUserLinkController(
                          //       context, urlController.text.toString());
                          //   // Downloader().downloader('https://twitter.com/TweetsOfCats/status/1574752181101682693?s=20&t=zrs1nuBPtduO8AnVWtRPag', 'hello.mp4');
                          // }
                        } else {
                          log("Permission is Denied");
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Download',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          progress > 0
              ? LinearPercentIndicator(
                  barRadius: const Radius.circular(10),
                  trailing: Text("$progress%"),
                  percent: progress / 100,
                  // progressColor: Colors.green,
                  linearGradient: const LinearGradient(
                      colors: [Color(0xFF666699), Color(0xFF666699)]),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
