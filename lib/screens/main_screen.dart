import 'package:artiluxio/screens/help_screen.dart';
import 'package:artiluxio/screens/image_screen.dart';
import 'package:artiluxio/screens/inference_screen.dart';
import 'package:artiluxio/screens/widgets/floatting_button.dart';
import 'package:artiluxio/screens/widgets/last_inferences.dart';
import 'package:artiluxio/screens/widgets/model_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/app_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MainScreen extends StatelessWidget {
  // Atributes
  final String title = "ArtiLuxio";
  final double imgSize = 125.0;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  MainScreen({super.key});

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
  Widget itemBuilder(BuildContext context, int i) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageScreen(
                    path: 'assets/images/example.jpg', isAssetImage: true)),
          );
        }, // Image tapped
        splashColor: Colors.black87,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Ink.image(
              image: const AssetImage('assets/images/example.jpg'),
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
      body: Column(
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
          ModelSelector(isDarkMode: isDarkMode, models: models),

          ////////////////////////
          /// Last Inferences
          ///////////////////////
          LastInferences(
            imgSize: imgSize,
            itemBuilder: itemBuilder,
          )
        ],
      ),

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
