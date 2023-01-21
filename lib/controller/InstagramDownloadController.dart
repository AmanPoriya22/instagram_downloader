import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../common/Downloader.dart';
import '../model/insta_post_with_login.dart';
import '../model/insta_post_without_login.dart';
import '../model/insta_reel_with_login.dart';
import '../model/insta_reel_without_login.dart';
import 'InstagramLoginController.dart';

class InstagramDownloadController {
  bool isLogin = false;
  String? time;
  List? allVideos;

  // Future Downloader().downloader(String url, String title) async {
  //
  //   final appDocDir = await getExternalStorageDirectory();
  //   String appDocPath = appDocDir!.path;
  //   log('App location : $appDocPath');
  //
  //   // if (isDownload == true) {
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: url.toString(),
  //       savedDir: appDocPath,
  //       fileName: title,
  //       showNotification: true, // show download progress in status bar (for Android)
  //       openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  //     ).onError((error, stackTrace) {
  //       log('DownloadError : ${error.toString()}');
  //       return null;
  //     });
  //     log(taskId.toString());
  //
  //     // return "file://$appDocPath/${videoTitle[0]}.mp4";
  //   // } else {
  //   //   MyWidget().toast('File is present on device');
  //   //   log("File is present on device");
  //   //   return null;
  //   // }
  // }


  Future downloadReels(BuildContext context, String link) async {
    String? videoUrl;
    double? videoDuration;

    isLogin = false;

    // Checking for Cookies

    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('isLogin')) {
      isLogin = prefs.getBool('isLogin')!;
    }

    final cookieManager = WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/');
    log(gotCookies.toString());

    try {
      // Create Part of link to get Json Format of data
      var linkParts = link.replaceAll(" ", "").split("/");
      var request = await HttpClient().getUrl(Uri.parse('${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}' + "/?__a=1&__d=dis"));
      // log("request : ${request}");

      for (var element in gotCookies) {
        request.cookies.add(Cookie(element.name, element.value));
      }
      var response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        // log("Data : ${data}");

        //used to manage and get download url of Instagram reels link
        if (isLogin == false) {

          // Used When user is not Login with instagram
          InstaReelWithoutLogin instaReelWithoutLogin = InstaReelWithoutLogin.fromJson(data);
          videoUrl = instaReelWithoutLogin.graphql?.shortcodeMedia?.videoUrl;
          videoDuration = instaReelWithoutLogin.graphql?.shortcodeMedia?.videoDuration;
          log("My Url Without Login : $videoUrl");
          log("videoDuration Without Login : $videoDuration");
        } else {

          // Used When user is not Login with instagram
          InstaReelWithLogin instaReelWithLogin = InstaReelWithLogin.fromJson(data);
          videoUrl = instaReelWithLogin.items?.first.videoVersions?.first.url;
          videoDuration = instaReelWithLogin.items?.first.videoDuration;
          log("My Url With Login : ${videoUrl.toString()}");
          log("videoDuration With Login : ${videoDuration.toString()}");
        }
      }

      var videoLinkParts = videoUrl.toString().replaceAll(" ", "").split("/");
      var videoTitle = videoLinkParts[videoLinkParts.length - 1].split('.mp4');
      log("Video Title : ${videoTitle[0]}");

      Downloader().downloader(videoUrl.toString(), "instagram_${videoTitle[0]}.mp4");
      // Downloader().requestDownload(videoUrl.toString(), "${videoTitle[0]}.mp4");

    } on FormatException catch (_, error) {
      log('OOOO : ${error.toString()}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => InstagramLoginController()));
    } catch (error) {
      log('1111 : ${error.toString()}');
    }




  }


  Future downloadPost(BuildContext context, String link) async {
    log('link : $link');
    log('Post Download Code');

    String? imageUrl;

    isLogin = false;

    // Checking for Cookies
    final cookieManager = WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/');
    log(gotCookies.toString());
    // is Cookie found then set isLogin to true
    // if (gotCookies.isNotEmpty) {
    //   isLogin = true;
    // }

    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('isLogin')) {
      isLogin = prefs.getBool('isLogin')!;
    }

    try {
      // Create Part of link to get Json Format of data
      var linkParts = link.replaceAll(" ", "").split("/");
      var request = await HttpClient().getUrl(Uri.parse(
          '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}/?__a=1&__d=dis'));
      // log("request : ${request}");

      for (var element in gotCookies) {
        request.cookies.add(Cookie(element.name, element.value));
      }
      var response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);

        //used to manage and get download url of Instagram reels link
        if (isLogin == false) {

          // Used When user is not Login with instagram
          InstaPostWithoutLogin post = InstaPostWithoutLogin.fromJson(data);
          if(post.graphql?.shortcodeMedia?.displayUrl == null){
            post.graphql?.shortcodeMedia?.edgeSidecarToChildren?.edges?.forEach((element) async {

              var linkParts = element.node?.displayUrl?.replaceAll(" ", "").split("/");
              var imageTitle = linkParts![linkParts.length - 1].split('.');
              log("Image Title : ${imageTitle[0]}");

              await Downloader().downloader(element.node!.displayUrl.toString(), "instagram_${imageTitle[0]}.png");

            });

          } else {
            var linkParts = post.graphql?.shortcodeMedia?.displayUrl?.replaceAll(" ", "").split("/");
            var imageTitle = linkParts![linkParts.length - 1].split('.');
            log("Video Title : ${imageTitle[0]}");

            await Downloader().downloader(post.graphql!.shortcodeMedia!.displayUrl.toString(), "instagram_${imageTitle[0]}.png");
          }

        } else {

          // Used When user is Login with instagram
          InstaPostWithLogin getInstaPost = InstaPostWithLogin.fromJson(data);

          log('length ${getInstaPost.items?.first.carouselMedia?.length}');

          if(getInstaPost.items?.first.carouselMedia?.length != null){
            getInstaPost.items?.first.carouselMedia?.forEach((element) async {
              log('AAAA : ${element.imageVersions2?.candidates?.first.url}');

              var linkParts = element.imageVersions2?.candidates?.first.url?.replaceAll(" ", "").split("/");
              var imageTitle = linkParts![linkParts.length - 1].split('.');
              log("Video Title : ${imageTitle[0]}");

              await Downloader().downloader(element.imageVersions2!.candidates!.first.url.toString(), "instagram_${imageTitle[0]}.png");
            });
          } else {
            imageUrl = getInstaPost.items?.first.imageVersions2?.candidates?.first.url;
              log('AAAA : $imageUrl');

              var linkParts = imageUrl.toString().replaceAll(" ", "").split("/");
              var imageTitle = linkParts[linkParts.length - 1].split('.');
              log("Video Title : ${imageTitle[0]}");

              await Downloader().downloader(imageUrl.toString(), "instagram_${imageTitle[0]}.png");
          }
          log("My Url : $imageUrl");
        }
      }
    } on FormatException catch (_, error) {
      log('OOOO : ${error.toString()}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => InstagramLoginController()));
    } catch (error) {
      log('1111 : ${error.toString()}');
    }


  }


  Future downloadVideo() async {
    log('Long Video Download Code');
  }

}
