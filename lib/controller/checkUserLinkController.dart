import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_videos_downloader/controller/twitterDownloadController.dart';
import 'package:twitter_extractor/twitter_extractor.dart';

import 'InstagramDownloadController.dart';
import 'YoutubeDownloadController.dart';

class CheckUserLink {
  // Future downloaderForFacebook(String link) async {
  //   FacebookPost data = await FacebookData.postFromUrl(link);
  //   print(data.postUrl);
  //   print(data.videoHdUrl);
  //   print(data.videoMp3Url);
  //   print(data.videoSdUrl);
  //   print(data.commentsCount);
  //   print(data.sharesCount);
  // }

  Future checkUserLinkController(BuildContext context, String link) async {
    List? linkParts = link.replaceAll(' ', '').split('/');

    print('parts : ${linkParts}');
    print('parts : ${linkParts[2]}');

    switch (linkParts[2]) {
      case 'www.instagram.com':
        switch (linkParts[3]) {
          case 'reel':
            await InstagramDownloadController()
                .downloadReels(context, link.toString());
            break;

          case 'p':
            await InstagramDownloadController()
                .downloadPost(context, link.toString());
            break;

          case 'tv':
            await InstagramDownloadController().downloadVideo();
            break;
        }
        break;

      case 'youtu.be':
        log('Video From Youtube');
        YoutubeDownloadController().extractYoutubeLink(link.toString());
        break;

      case 'youtube.com':
        log('Short From Youtube');
        YoutubeDownloadController().extractYoutubeLink(link.toString());
        break;

      case 'twitter.com':
        log('link From twitter');
        TwitterDownloadController().twitterDownloader(link.toString());
        break;

      // case 'www.facebook.com' :
      //   log('Video from Facebook');
      //   // downloaderForFacebook(link);
      //
      // break;
      //
      // case 'fb.watch' :
      //   log('Video from Facebook');
      //   // downloaderForFacebook(link);
      // break;

    }
  }
}
