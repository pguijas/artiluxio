import 'dart:io';

import '../model/model.dart';
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
    callback(context, pickedFile.path);
  }

  void _inference(
      String imgPath, String stylePath, StyleTransferer model) async {
    // Inference
    File inputFile = File(imgPath);
    File styleFile = File(stylePath);
    if (model.notLoaded) await model.loadModel();
    String output = await model.transfer(inputFile, styleFile);
    // Notify
    add(InferenceDoneEvent(output));
  }

  void _pick_and_inference(String imgPath, StyleTransferer model) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      add(InferenceDoneEvent(""));
      return;
    }
    _inference(imgPath, pickedFile.path, model);
  }

  AppBloc() : super(AppBlocState(styleIndex: 0, actualInferencePath: "")) {
    // STYLE IMAGES
    var l = Iterable<int>.generate(25).toList();
    styleImages = l.map((e) => "assets/style_images/style$e.jpg").toList();

    // ADDED STYLE IMAGE
    on<ChangedStyleImageEvent>((event, emit) {
      // Notify that inference is running
      add(RunningInferenceEvent());

      // Check if none or custom image
      switch (event.styleIndex) {
        case 0:
          emit(AppBlocState(
              styleIndex: event.styleIndex, actualInferencePath: ""));
          break;

        case 1:
          // Load image (from galery)
          _pick_and_inference(event.sourceImagePath, state.model);
          break;

        default:
          _inference(event.sourceImagePath, styleImages[event.styleIndex - 2],
              state.model);
          break;
      }
    });

    on<RunningInferenceEvent>((event, emit) {
      print("Running Inference Event");
      emit(AppBlocState(
          styleIndex: state.styleIndex,
          actualInferencePath: state.actualInferencePath,
          runningInference: true));
    });

    on<InferenceDoneEvent>((event, emit) {
      print("Inference Done Event");
      emit(AppBlocState(
          styleIndex: state.styleIndex,
          actualInferencePath: event.inferencePath,
          runningInference: false));
    });
  }
}
