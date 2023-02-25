import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class InferenceScreen extends StatelessWidget {
  String imgPath;
  AppBloc appBloc;
  final double imgSize = 110.0;

  InferenceScreen(this.imgPath, this.appBloc, {super.key});

  Widget itembluider(List<String> styleImages, int i, bool isDarkMode) {
    switch (i) {
      case 0:
        {
          return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                  onTap: () {
                    print("miau");
                  }, // Image tapped
                  splashColor: Colors.black87,
                  child: Container(
                    height: imgSize,
                    width: imgSize,
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    child: const Center(
                      child: Icon(Icons.auto_fix_off),
                    ),
                  )));
        }

      case 1:
        {
          return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                  onTap: () {
                    print("miau");
                  }, // Image tapped
                  splashColor: Colors.black87,
                  child: Container(
                    height: imgSize,
                    width: imgSize,
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    child: const Center(
                      child: Icon(Icons.add_photo_alternate),
                    ),
                  )));
        }

      default:
        {
          return ClipRRect(
              borderRadius: BorderRadius.circular(5), // no funciona ----- -----
              child: InkWell(
                  onTap: () {
                    print("miau");
                  }, // Image tapped
                  splashColor: Colors.black87,
                  child: Image(
                    image: AssetImage(styleImages[i - 2]),
                    height: imgSize,
                    width: imgSize,
                    fit: BoxFit.cover,
                  )));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> styleImages = appBloc.styleImages;

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

          Container(
            margin: const EdgeInsets.only(top: 35.0),
            child: SizedBox(
              height: imgSize,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(0),
                itemCount: styleImages.length +
                    2, // +2 because of None and Custom Image
                itemBuilder: (_, i) => itembluider(styleImages, i, isDarkMode),
                separatorBuilder: (_, i) => const SizedBox(width: 10),
              ),
            ),
          ),

          //
        ],
      ),
    );
  }
}
