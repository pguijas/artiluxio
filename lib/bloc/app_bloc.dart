import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  List<String> models = ["example.tflite"];
  List<String> styleImages = [];

  final picker = ImagePicker();

  void getInputImage(fromCam, context, callback) async {
    ImageSource source = fromCam ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    print("Image Path: ${pickedFile.path}");
    callback(context, pickedFile.path);
  }

  AppBloc()
      : super(AppBlocState(
            styleIndex: 0, customStylePath: "", actualInferencePath: "")) {
    // STYLE IMAGES
    var l = Iterable<int>.generate(25).toList();
    styleImages = l.map((e) => "assets/style_images/style$e.jpg").toList();

    /*
    // MODEL LOADED
    on<ModelLoadedEvent>((event, emit) {
      print("Model Loaded Event");
      //si state es initial, carga pantalla inicial (antes pantalla con logo)
    });

    // ADDED SOURCE IMAGE
    on<AddedSourceImageEvent>((event, emit) {
      print("Added Source Image Event");
      //si state es AppBlocModelLoaded cambia a pantalla inferencia
    });
    */
    // ADDED STYLE IMAGE
    on<ChangedStyleImageEvent>((event, emit) {
      print("Added Style Image Event");
      emit(AppBlocState(
          styleIndex: event.styleIndex,
          customStylePath: event.customStylePath,
          actualInferencePath: state.actualInferencePath));
      //si estate es AppBlocImgSelected muestra la inferencia (y la cachea y tal)
    });
  }
}
