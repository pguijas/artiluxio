import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_bloc.dart';

class InferenceScreen extends StatelessWidget {
  // Atributes
  String imgPath;
  AppBloc appBloc;
  final double imgSize = 110.0;

  InferenceScreen(this.imgPath, this.appBloc, {super.key});

  // Image Style Builder
  Widget itembluider(List<String> styleImages, int i, int selIndex,
      bool isDarkMode, Color borderColor) {
    Widget res;
    switch (i) {
      case 0:
        {
          res = ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                  onTap: () {
                    appBloc.add(ChangedStyleImageEvent(
                        sourceImagePath: imgPath, styleIndex: i));
                  }, // Image tapped
                  splashColor: Colors.black87,
                  child: Container(
                    height: imgSize,
                    width: imgSize,
                    color: isDarkMode ? Colors.white10 : Colors.black12,
                    child: const Center(child: Icon(Icons.auto_fix_off)),
                  )));
        }
        break;

      case 1:
        {
          res = ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                  onTap: () {
                    appBloc.add(ChangedStyleImageEvent(
                        sourceImagePath: imgPath, styleIndex: i));
                  }, // Image tapped// Image tapped
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
        break;

      default:
        {
          res = ClipRRect(
              borderRadius: BorderRadius.circular(5), // no funciona ----- -----
              child: InkWell(
                  onTap: () {
                    appBloc.add(ChangedStyleImageEvent(
                        sourceImagePath: imgPath, styleIndex: i));
                  }, // Image tapped
                  splashColor: Colors.black87,
                  child: Image(
                    image: AssetImage(styleImages[i - 2]),
                    height: imgSize,
                    width: imgSize,
                    fit: BoxFit.cover,
                  )));
        }
        break;
    }

    if (i == selIndex) {
      return Container(
        height: imgSize,
        width: imgSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blueAccent, width: 3)),
        child: res,
      );
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    List<String> styleImages = appBloc.styleImages;
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return BlocBuilder<AppBloc, AppBlocState>(
        bloc: appBloc,
        builder: (context, state) {
          Widget image;
          if (state.runningInference) {
            image = const Center(child: CircularProgressIndicator());
          } else {
            image = Image(
              image: state.actualInferencePath == ""
                  ? Image.file(File(imgPath)).image
                  : Image.file(File(state.actualInferencePath)).image,
              height: 500,
              width: 350,
              fit: BoxFit.cover,
            );
          }

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
                //////////////////
                // Result Image
                //////////////////
                Container(
                  width: double.infinity,
                  height: 500,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 20.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0), child: image),
                ),

                //////////////////
                /// Style Images
                //////////////////
                Container(
                  margin: const EdgeInsets.only(top: 35.0),
                  child: SizedBox(
                    height: imgSize,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(0),
                      itemCount: styleImages.length +
                          2, // +2 because of None and Custom Image
                      itemBuilder: (_, i) => itembluider(
                          styleImages,
                          i,
                          state.styleIndex,
                          isDarkMode,
                          Theme.of(context).colorScheme.primary),
                      separatorBuilder: (_, i) => const SizedBox(width: 10),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
