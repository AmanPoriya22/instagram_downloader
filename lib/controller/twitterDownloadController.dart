import 'package:instagram_videos_downloader/common/Downloader.dart';
import 'package:twitter_extractor/twitter_extractor.dart';

class TwitterDownloadController{
  Future twitterDownloader(String link) async {
    final data = await TwitterExtractor.extract(link.toString());

    print(data.videos.first.type);
    List? linkParts = data.videos.first.url.replaceAll(' ', '').split('/');
    List? title = linkParts[linkParts.length-1].toString().split('.');

    String? finalTitle;

    switch (data.videos.first.type){
      case 'image' :
        finalTitle = "twitter_${title[0].toString()}.png";
        break;
      case 'video' :
        finalTitle = "twitter_${title[0].toString()}.mp4";
        break;
    }

    print('AAAAAparts : ${linkParts[linkParts.length-1]}');

    await Downloader().downloader(data.videos.first.url, finalTitle!);
  }
}