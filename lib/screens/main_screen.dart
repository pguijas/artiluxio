import 'package:artiluxio/screens/help_screen.dart';
import 'package:artiluxio/screens/image_screen.dart';
import 'package:artiluxio/screens/inference_screen.dart';
import 'package:artiluxio/screens/widgets/floatting_button.dart';
import 'package:artiluxio/screens/widgets/last_inferences.dart';
import 'package:artiluxio/screens/widgets/model_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc/app_bloc.dart';
import 'dart:io';

class MainScreen extends StatelessWidget {
  // Atributes
  final String title = "ArtiLuxio";
  final double imgSize = 125.0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  MainScreen({super.key}) {
    lastInferencesFuture = readLastInferences();
  }

  // Read last inferences
  late Future<List<String>> lastInferencesFuture;
  Future<List<String>> readLastInferences() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory inferenceDir = Directory("${dir.path}/inferences/");
    Stream<FileSystemEntity> fileStream = inferenceDir.list();

    List<String> lastInferences = [];
    await for (FileSystemEntity file in fileStream) {
      lastInferences.add(file.path);
    }

    return lastInferences;
  }

  // goInference Callback
  void goInference(BuildContext context, String imgPath) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InferenceScreen(imgPath, appBloc)),
    );
  }

  // goToSettings Callback
  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  // itemBuilder Generator (last inferences)
  Widget itemBuilder(BuildContext context, int i, List<String> images) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageScreen(path: images[i])),
          );
        }, // Image tapped
        splashColor: Colors.black87,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Ink.image(
              image: FileImage(File(images[i])),
              height: imgSize,
              width: imgSize,
              fit: BoxFit.cover,
            )));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    List<String> models = BlocProvider.of<AppBloc>(context).models;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          height: 30,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            color: isDarkMode ? Colors.white : Colors.black,
            onPressed: () {
              goToSettings(context);
            },
          ),
        ],
      ),

      // Body
      body: BlocBuilder<AppBloc, AppBlocState>(builder: (context, state) {
        return Column(
          children: [
            ///////////////////
            /// Hello! Text
            ///////////////////
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ),

            ////////////////////////
            /// Model Selectior
            ///////////////////////
            ModelSelector(
              isDarkMode: isDarkMode,
              models: models,
              selectedModel: state.modelIndex,
              onChanged: (i) =>
                  BlocProvider.of<AppBloc>(context).add(ChangedModelEvent(i)),
            ),

            ////////////////////////
            /// Last Inferences
            ///////////////////////
            FutureBuilder<List<String>>(
                future: lastInferencesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  List<Widget> children;
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    children = <Widget>[Text("No previous inferences.")];
                  } else {
                    children = <Widget>[
                      LastInferences(
                        imgSize: imgSize,
                        itemBuilder: itemBuilder,
                        images: snapshot.data!,
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                }),
          ],
        );
      }),

      //////////////////////////////
      // Centered Floating Button
      //////////////////////////////
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloattingButton(
        isDialOpen: isDialOpen,
        onCamera: () {
          BlocProvider.of<AppBloc>(context)
              .getInputImage(true, context, goInference);
          isDialOpen.value = false;
        },
        onGallery: () {
          BlocProvider.of<AppBloc>(context)
              .getInputImage(false, context, goInference);
          isDialOpen.value = false;
        },
      ),
    );
  }
}
