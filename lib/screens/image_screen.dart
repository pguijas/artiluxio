import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ImageScreen extends StatelessWidget {
  late ImageProvider image;
  final String path;

  ImageScreen({required this.path, super.key}) {
    image = FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.share),
              onPressed: () =>
                  Share.shareFiles([path], text: 'Look at this cool image!')),
        ],
      ),
      body: PhotoView(imageProvider: image),
    );
  }
}
