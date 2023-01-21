import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer(this.path, {Key? key}) : super(key: key);

  final String path;

  @override
  MyVideoPlayerState createState() => MyVideoPlayerState();
}

class MyVideoPlayerState extends State<MyVideoPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(File(widget.path)),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                closedCaptionTextStyle: TextStyle(fontSize: 8),
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                controls: FlickLandscapeControls(),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: ClipOval(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.black45,
                    child: const Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}