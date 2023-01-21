import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:instagram_videos_downloader/viewer/flickVideoPlayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'common/MyInterstitialAd.dart';
import 'widget/MyWidget.dart';

class GenerateVideoFromPath extends StatefulWidget {
  const GenerateVideoFromPath(this.path, {Key? key})
      : super(key: key);

  final String path;

  @override
  State<GenerateVideoFromPath> createState() => _GenerateVideoFromPathState();
}

class _GenerateVideoFromPathState extends State<GenerateVideoFromPath> {
  final videoInfo = FlutterVideoInfo();

  var uint8list;
  bool videoLoading = true;
  String? videoPath;
  String? videoDuration;
  String videoModificationDate = '';
  String? videoTitle;
  static int loadAd = 0;

  @override
  void initState() {
    getVideoDetails();
    super.initState();
  }

  getVideoDetails() async {

    var part = widget.path.replaceAll(' ', '').replaceAll('\'', '').split('/');
    print('part : $part');

    final stat = FileStat.statSync('/${part[1]}/${part[2]}/${part[3]}/${part[4]}/${part[5]}/${part[6]}/${part[7]}/${part[8]}');
    print('QQQQ : ${stat.modified}');

    var info = await videoInfo.getVideoInfo('/${part[1]}/${part[2]}/${part[3]}/${part[4]}/${part[5]}/${part[6]}/${part[7]}/${part[8]}');

    print('duration : ${info!.duration}');
    print('title : ${info.title}');
    print('date : ${info.date}');
    print('mimetype : ${info.mimetype}');
    print('path : ${info.path}');

    setState(() {
      videoTitle = info.title;
      videoPath = info.path;
      videoDuration = printDuration(Duration(milliseconds: info.duration!.toInt()));
      videoModificationDate = stat.modified.toString();
      print('videoModificationDate :: ${videoModificationDate}');
    });

    await generateThumb();
  }

  generateThumb() async {
    await VideoThumbnail.thumbnailData(
      video: 'file:///$videoPath',
      imageFormat: ImageFormat.PNG,
      maxWidth: 500,
      quality: 100,
    ).then((value) {
      setState(() {
        uint8list = value;
        videoLoading = false;
      });
    });
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          print('count : ${loadAd}');
          setState(() {
            loadAd = (loadAd + 1);
            if (loadAd == 5) {
              MyInterstitialAd.loadInterstitialAd(
                  context, File(videoPath.toString()), 'Video');
              loadAd = 0;
            } else {
              print('AAAAAAAAAA : file:///$videoPath');
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyVideoPlayer('file:///$videoPath')));
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyBetterVideoPlayerController()));
            }
          });
        },
        child: Row(
          children: [
            videoLoading
                ? const SizedBox(
                    width: 130,
                    height: 130,
                    child: CupertinoActivityIndicator(),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            // image: type == 'mp4'
                            //     ? DecorationImage(image: MemoryImage(uint8list), fit: BoxFit.cover)
                            //     : DecorationImage(image: FileImage(File(widget.path)), fit: BoxFit.cover),
                          ),
                          child: Image.memory(uint8list, fit: BoxFit.cover),
                        ),
                      ),
                      ClipOval(
                        child: Container(
                          color: Colors.black38,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 110,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text('${videoTitle.toString()}.mp4'),
                          ),
                          Expanded(
                            flex: 1,
                            child: PopupMenuButton<String>(
                              onSelected: (String value) {
                                handleClick(
                                    context,
                                    value,
                                    videoPath.toString(),
                                    videoTitle.toString());
                              },
                              itemBuilder: (BuildContext context) {
                                return {'Share', 'Delete'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text(videoModificationDate == '' ? '' : videoModificationDate.toString().replaceRange(videoModificationDate.toString().length - 4, videoModificationDate.toString().length, '')),
                          Text(videoDuration.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // } else {
    // return imageLoading
    //     ? const CupertinoActivityIndicator()
    //     : Card(
    //         clipBehavior: Clip.hardEdge,
    //         child: InkWell(
    //           onTap: () {
    //             // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer('file:///$videoPath')));
    //           },
    //           child: Row(
    //             children: [
    //               Stack(
    //                 alignment: Alignment.center,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(left: 0.0),
    //                     child: Container(
    //                       width: 130,
    //                       height: 130,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(0),
    //                         // DecorationImage(image: FileImage(File(widget.path)), fit: BoxFit.cover),
    //                       ),
    //                       child: Image.file(imagePath!, fit: BoxFit.cover),
    //                     ),
    //                   ),
    //                   ClipOval(
    //                     child: Container(
    //                       color: Colors.black38,
    //                       child: const Padding(
    //                         padding: EdgeInsets.all(8.0),
    //                         child: Icon(
    //                           Icons.image_outlined,
    //                           size: 25,
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               const SizedBox(width: 10),
    //               Expanded(
    //                 child: Container(
    //                   height: 110,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(left: 5.0, right: 10),
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       crossAxisAlignment: CrossAxisAlignment.end,
    //                       children: [
    //                         Row(
    //                           children: [
    //                             Expanded(
    //                               flex: 10,
    //                               child: Text('${imageTitle.toString()}'),
    //                             ),
    //                             Expanded(
    //                               flex: 1,
    //                               child: PopupMenuButton<String>(
    //                                 onSelected: handleClick,
    //                                 itemBuilder: (BuildContext context) {
    //                                   return {'Share', 'Delete'}
    //                                       .map((String choice) {
    //                                     return PopupMenuItem<String>(
    //                                       value: choice,
    //                                       child: Text(choice),
    //                                     );
    //                                   }).toList();
    //                                 },
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         // Row(
    //                         //   mainAxisAlignment: MainAxisAlignment.end,
    //                         //   children: [
    //                         //     Text('${videoDuration.toString()}'),
    //                         //   ],
    //                         // ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    // }
  }
}
