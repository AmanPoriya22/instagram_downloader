import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  ImageViewer(this.image, {Key? key}) : super(key: key);

  File image;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: FileImage(widget.image),
        loadingBuilder: (context, progress) => const Center(child: CircularProgressIndicator()),
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        gaplessPlayback: false,
        customSize: MediaQuery.of(context).size,
        enableRotation: false,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
      ),
    );
  }
}
