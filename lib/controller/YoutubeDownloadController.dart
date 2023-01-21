import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:youtube_video_info/open_graph.dart';
import 'package:youtube_video_info/youtube.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../common/Downloader.dart';

class YoutubeDownloadController{

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> extractYoutubeLink(String youTubeLink) async {

    YoutubeDataModel videoData = await YoutubeData.getData(youTubeLink);
    String title = videoData.title.toString().replaceAll(' ', '_');
    developer.log('YtTitle : ${title}');
    developer.log('YtTitle : ${videoData.type}');
    developer.log('YtTitle : ${videoData.durationSeconds}');

    String link;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      link = await FlutterYoutubeDownloader.extractYoutubeLink(youTubeLink, 18);
    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    await Downloader().downloader(link, '$title.mp4');

    print('ytLink :: ${link}');
    return link;

  }

  Future<void> downloadVideo(String youTubeLink) async {
    final result = await FlutterYoutubeDownloader.downloadVideo(
        youTubeLink, "Video Title goes Here", 18);
    print(result);
  }

}