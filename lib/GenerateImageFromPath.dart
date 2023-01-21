
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_videos_downloader/viewer/ImageViewer.dart';

import 'widget/MyWidget.dart';
import 'common/MyInterstitialAd.dart';

class GenerateImageFromPath extends StatefulWidget {
  GenerateImageFromPath(this.imagePath, this.imageTitle, {Key? key}) : super(key: key);

  File imagePath;
  String imageTitle;

  @override
  State<GenerateImageFromPath> createState() => _GenerateImageFromPathState();
}

class _GenerateImageFromPathState extends State<GenerateImageFromPath> {

  String? _imageTitle;
  String? _imagePath;
  String _imageModificationDate = '';
  static int loadAd = 0;

  @override
  void initState() {

    getImageFileTitle();
    super.initState();
  }


  getImageFileTitle(){
    print('title ${widget.imageTitle}');
    var titleParts = widget.imageTitle
        .toString()
        .replaceAll(' ', '')
        .replaceAll('\'', '')
        .split('/');
    _imageTitle = titleParts[titleParts.length - 1];
    print('ooo : ${titleParts[titleParts.length - 1]}');

    var pathParts = widget.imagePath
        .toString()
        .replaceAll(' ', '')
        .replaceAll('\'', '')
        .split('/');
    _imagePath = '${pathParts[1]}/${pathParts[2]}/${pathParts[3]}/${pathParts[4]}/${pathParts[5]}/${pathParts[6]}/${pathParts[7]}/${pathParts[8]}';
    print('VVV : $_imagePath');

    final stat = FileStat.statSync('/$_imagePath');
    _imageModificationDate = stat.modified.toString();
    print('AAAAAAA : ${stat.modified}');

  }


  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          print('count : $loadAd');
          setState((){
            loadAd = (loadAd+ 1);
            if(loadAd == 5){
              MyInterstitialAd.loadInterstitialAd(context, widget.imagePath, 'Image');
              loadAd = 0;
            }
            else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(widget.imagePath)));
            }
          });
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      // DecorationImage(image: FileImage(File(widget.path)), fit: BoxFit.cover),
                    ),
                    child:
                    Image.file(widget.imagePath, fit: BoxFit.cover),
                  ),
                ),
                ClipOval(
                  child: Container(
                    color: Colors.black38,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.image_outlined,
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
              child: SizedBox(
                height: 110,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 5.0, right: 10),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child:
                            Text('${_imageTitle.toString()}.png'),
                          ),
                          Expanded(
                            flex: 1,
                            child: PopupMenuButton<String>(
                              onSelected: (String value) {
                                handleClick(
                                    context,
                                    value,
                                    _imagePath.toString(),
                                    '${_imageTitle.toString()}.png');
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
                      Text(_imageModificationDate == '' ? '' : _imageModificationDate.toString().replaceRange(_imageModificationDate.toString().length - 4, _imageModificationDate.toString().length, ''))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
