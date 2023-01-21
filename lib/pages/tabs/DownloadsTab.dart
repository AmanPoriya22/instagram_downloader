
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../GenerateImageFromPath.dart';
import '../../GenerateVideoFromPath.dart';

class DownloadsTab extends StatefulWidget {
  const DownloadsTab({Key? key}) : super(key: key);

  @override
  DownloadsTabState createState() => DownloadsTabState();
}

class DownloadsTabState extends State<DownloadsTab> {
  bool loadingVideos = true;

  List? filePath;
  String? videoPath;
  String? imagePath;

  @override
  void initState() {
    loadingVideos = false;
    getFiles();
    super.initState();
    setState(() {});
  }


  getFiles() async {
    final dir = await getExternalStorageDirectory();

    await dir?.list().toList().then((value) {
      setState(() {
        filePath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: (filePath != null && filePath!.isNotEmpty)
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: (loadingVideos)
                        ? const Center(child: CupertinoActivityIndicator())
                        : StreamBuilder(
                          stream: getExternalStorageDirectory().asStream(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemCount: filePath!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var linkParts = filePath![index]
                                      .toString()
                                      .replaceAll(' ', '')
                                      .replaceAll('\'', '')
                                      .split('.');
                                  // print('ooo : ${linkParts[linkParts.length - 1]}');

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 1.0),
                                    child: Column(
                                      children: [
                                        if (linkParts[linkParts.length - 1] == 'mp4')
                                          GenerateVideoFromPath(filePath![index].toString())
                                        else if (linkParts[linkParts.length - 1] == 'png')
                                          GenerateImageFromPath(filePath![index], linkParts[linkParts.length - 2]),
                                      ],
                                    ),
                                  );
                                },
                               /* separatorBuilder: (BuildContext context, int index) {
                                  return (index != 0 && index % 5 == 0)
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 1.0),
                                          child: SizedBox(
                                            height: 130,
                                            child: Card(
                                              child: AdWidget(
                                                ad: MyBannerAd().bannerAd(AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(MediaQuery.of(context).size.height.toInt())),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                },*/
                              );
                          }
                        ),
                  )
                : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.video_collection_outlined,size: 60,color: Colors.black54),
                      SizedBox(height: 10,),
                      Text("No Video Downloaded Yet!\n   Please download now.",
                      style: TextStyle(fontSize: 16, letterSpacing: 1, color: Colors.black54),),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
