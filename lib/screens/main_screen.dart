import 'package:artiluxio/screens/help_screen.dart';
import 'package:artiluxio/screens/image_screen.dart';
import 'package:artiluxio/screens/interence_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/app_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/*
Main Screen Content:
  - App Bar (title and settings button)
  - Body
    - Last Inferences (laterally scrollable)
    - Load Model Button
  - Floating Button (new inference)


AQUI VA  ATOCAR DIVIDIR TODO EN COMPONENTES
*/

class MainScreen extends StatelessWidget {
  final String title = "ArtiLuxio";
  final double imgSize = 125.0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late List<String> lastInferences = [];

  MainScreen() {
    readLastInferences();
  }

  Future<bool> readLastInferences() async {
    lastInferences = [];

    Directory dir = await getApplicationDocumentsDirectory();
    Directory inferenceDir = Directory(dir.path + "/inferences/");
    Stream<FileSystemEntity> fileStream = inferenceDir.list();

    // Bug: this function is executed multiple times, so the list contains
    // repeated list of elements. We use idx to overwrite the (same) image if
    // it already exists, otherwise the element is appended to the end
    int idx = 0;
    await for (FileSystemEntity file in fileStream) {
      //file.deleteSync(recursive: true);  // to clean the folder
      if (idx >= lastInferences.length) {
        lastInferences.add(file.path);
      } else {
        lastInferences[idx] = file.path;
      }
      idx += 1;
    }

    return true;
  }

  void goInference(BuildContext context, String imgPath) {
    AppBloc appBloc = BlocProvider.of<AppBloc>(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InferenceScreen(imgPath, appBloc)),
    );
  }

  //_onImageButtonPressed(ImageSource.gallery, context: context);

  void goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  Widget itembluider(BuildContext context, int i) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageScreen(
                    path: lastInferences[i], isAssetImage: true)),
          );
        }, // Image tapped
        splashColor: Colors.black87,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Ink.image(
              image: FileImage(File(lastInferences[i])),
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

        // set same color as background
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
      body: Column(
        children: [
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

          Container(
            margin: const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 20.0),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Select Model:",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),

          // dropbox to select the model
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            height: 40.0,
            width: 150.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: isDarkMode
                    ? const Color.fromARGB(20, 255, 255, 255)
                    : const Color.fromARGB(20, 0, 0, 0)),
            child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: models[0],
                    // obtain the value from the bloc
                    items: models
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                            )))
                        .toList(),
                    onChanged: (value) {
                      print(value);
                    }) // your Dropdown Widget here
                ),
          ),
          Container(
              margin:
                  const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Your last Inferences:",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w300),
                ),
              )),

          // Last Inferences Scrollable
          FutureBuilder<bool>(
            future: readLastInferences(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                List<Widget> children;
                if (!snapshot.hasData || lastInferences.length == 0) {
                  children = <Widget>[Text("No previous inferences.")];
                } else {
                  children = <Widget>[
                    SizedBox(
                      height: imgSize,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(0),
                        itemCount: lastInferences.length,
                        itemBuilder: (_, i) => itembluider(context, i),
                        separatorBuilder: (_, i) => const SizedBox(width: 10),
                      ),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              }
          ),
          /*
          SizedBox(
            height: imgSize,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0),
              itemCount: lastInferences.length,
              itemBuilder: (_, i) => itembluider(context, i),
              separatorBuilder: (_, i) => const SizedBox(width: 10),
            ),
          ),

           */
        ],
      ),
      /*
        Center(
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<AppBloc>(context).add(ModelLoadedEvent("model"));
            },
            child: const Text("Load Model"),
          ),
        ),
        */

      // Centered Floating Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SpeedDial(
        backgroundColor:
            Theme.of(context).colorScheme.primary, // primary swatch
        animatedIcon: AnimatedIcons.menu_arrow,
        label: const Text("New Inference"),
        renderOverlay: true,
        spacing: 10,
        spaceBetweenChildren: 10,
        switchLabelPosition: true,
        openCloseDial: isDialOpen,

        children: [
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            label: "Camera",
            onTap: () {
              BlocProvider.of<AppBloc>(context)
                  .getInputImage(true, context, goInference);
              isDialOpen.value = false;
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_photo_alternate),
            label: "Gallery",
            onTap: () {
              BlocProvider.of<AppBloc>(context)
                  .getInputImage(false, context, goInference);
              isDialOpen.value = false;
            },
          ),
        ],
      ),
    );
  }
}
