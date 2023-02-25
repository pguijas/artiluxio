/*
* This file is part of the Artiluxio application (see https://github.com/pguijas/artiluxio).
* Copyright (C) 2023 Pedro Guijas | Elena Sánchez | Angel Miguélez
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
