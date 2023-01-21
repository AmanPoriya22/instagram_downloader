import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../viewer/ImageViewer.dart';
import '../viewer/flickVideoPlayer.dart';

class MyInterstitialAd {
  MyInterstitialAd.loadInterstitialAd(BuildContext context, File path, String type) {
    print('pathhhh === ${path}');
    InterstitialAd? interstitialAd;
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          interstitialAd!.show();
          interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdFailedToShowFullScreenContent: ((ad, error) {
            ad.dispose();
            interstitialAd!.dispose();
            debugPrint(error.message);
          }), onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            interstitialAd!.dispose();

            //Todo : Switch to different Screen.
            switch (type) {
              case 'Image':
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageViewer(path)));
                break;

              case 'Video':
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyVideoPlayer('file:///${path.path}')));
                print('AAABBB : file:///${path.path}');
                break;

                case 'Home': print('Home Page Ad');
                  break;
            }
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint(err.message);
        },
      ),
    );
  }
}
