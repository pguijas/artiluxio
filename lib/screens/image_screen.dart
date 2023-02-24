import 'package:flutter/material.dart';
import 'dart:io';

import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  ImageProvider image = const AssetImage('assets/images/example.png');

  ImageScreen({required String path, required bool isAssetImage, super.key}) {
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
        ),
        body: PhotoView(imageProvider: image));
  }
}
