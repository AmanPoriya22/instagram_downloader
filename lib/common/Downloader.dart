import 'dart:developer';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../widget/MyWidget.dart';

class Downloader {
  String? storedVideoName;

  Future downloader(String url, String title) async {
    // Save Location
    final appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir!.path;
    log('App location : $appDocPath');

    // Get Downloaded videos
    await appDocDir.list().toList().then((value) {
      log('val : $value');
      value.forEach((element) {
        var linkParts = element.toString().replaceAll(" ", "").split("/");
        storedVideoName = linkParts[8].replaceAll('\'', '');
        log('PPPP $storedVideoName');
        log('TITLE $title');
      });
    });

    /*
      if video is not downloaded so download it.
      if video is downloaded so not download it
    */

    if (storedVideoName.toString() != title.toString()) {
      final taskId = await FlutterDownloader.enqueue(
        url: url.toString(),
        savedDir: appDocPath,
        fileName: title,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      ).onError((error, stackTrace) {
        log('DownloadError : ${error.toString()}');
        return null;
      });
      log(taskId.toString());

      // return "file://$appDocPath/${videoTitle[0]}.mp4";

      try {
        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE status=3 AND progress<>0');
        final task = tasks!.firstWhere((task) => task.taskId == taskId);
        int progress = task.progress;
        log("progresssssss $progress");
      } catch (e) {
        log(e.toString());
      }
    } else {
      toast('$storedVideoName is already downloaded');
      log("$storedVideoName is already downloaded");
    }
  }

  // Future<void> requestDownload(String url, String name) async {
  //   final dir = await getExternalStorageDirectory(); //From path_provider package
  //   var localPath = dir!.path + name;
  //   final savedDir = Directory(localPath);
  //   await savedDir.create(recursive: true).then((value) async {
  //     String? taskId = await FlutterDownloader.enqueue(
  //       url: url,
  //       fileName: name,
  //       savedDir: localPath,
  //       showNotification: true,
  //       openFileFromNotification: false,
  //     );
  //     print(taskId);
  //   });
  // }

  /* --- */

// downloadFile(String url, {required String filename}) async {
//   var httpClient = http.Client();
//   var request = http.Request('GET', Uri.parse(url));
//   var response = httpClient.send(request);
//
//   final appDocDir = await getExternalStorageDirectory();
//   String appDocPath = appDocDir!.path;
//   log('App location : $appDocPath');
//
//   List<List<int>> chunks = [];
//   int downloaded = 0;
//
//   response.asStream().listen((http.StreamedResponse r) {
//
//     r.stream.listen((List<int> chunk) {
//       // Display percentage of completion
//       debugPrint('downloadPercentage1: ${downloaded / r.contentLength! * 100}');
//
//       chunks.add(chunk);
//       downloaded += chunk.length;
//     }, onDone: () async {
//       // Display percentage of completion
//       debugPrint('downloadPercentage2: ${downloaded / r.contentLength! * 100}');
//
//       // Save the file
//       File file = File('$appDocPath/$filename');
//       final Uint8List bytes = Uint8List(r.contentLength!);
//       int offset = 0;
//       for (List<int> chunk in chunks) {
//         bytes.setRange(offset, offset + chunk.length, chunk);
//         offset += chunk.length;
//       }
//       await file.writeAsBytes(bytes);
//       return;
//     });
//   });
// }
}
