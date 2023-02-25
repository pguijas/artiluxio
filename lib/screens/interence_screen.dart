import 'dart:io';
import 'package:flutter/material.dart';

class InferenceScreen extends StatelessWidget {
  String imgPath;

  InferenceScreen(this.imgPath, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // rounded container
          Container(
            width: double.infinity,
            height: 500,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: Image.file(File(imgPath)).image,
                height: 500,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //
        ],
      ),
    );
  }
}
