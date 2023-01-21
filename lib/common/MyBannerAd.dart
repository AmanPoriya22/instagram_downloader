import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd {
  bool adLoaded = false;


  BannerAd bannerAd(AdSize adSize){
    BannerAd bannerAd = BannerAd(
      size: adSize,

      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          adLoaded = true;
          print('Ad loaded.');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
    if(adLoaded == true){
      return bannerAd;
    }
    else {
      bannerAd.load();
      return bannerAd;
    }
  }

}