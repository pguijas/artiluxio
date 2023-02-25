import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  ImageProvider image = const AssetImage('assets/images/example.png');
  final String path;

  ImageScreen({required bool isAssetImage, required this.path, super.key}) {
    if (isAssetImage) {
      image = AssetImage(path);
    } else {
      image = FileImage(File(path));
    }
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
              onPressed: () => print("probar con share_extend"))
        ],
      ),
      body: PhotoView(imageProvider: image),
    );
  }
}
