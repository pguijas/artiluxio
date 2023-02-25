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

import 'dart:io';
import '../model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'app_bloc_event.dart';
part 'app_bloc_state.dart';

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  // Models and style images
  List<String> models = ["magenta_fp16", "magenta_int8"];
  List<String> styleImages = [];

  /////////////////////////
  /// Usefull functions
  /////////////////////////

  final picker = ImagePicker();

  // Obtein image from camera or gallery and callback
  void getInputImage(fromCam, context, callback) async {
    ImageSource source = fromCam ? ImageSource.camera : ImageSource.gallery;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    callback(context, pickedFile.path);
  }

  // Run inference (notifies)
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

  void _pickAndInference(String imgPath, StyleTransferer model) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      add(InferenceDoneEvent(""));
      return;
    }
    _inference(imgPath, pickedFile.path, model);
  }

  /////////////////////////////
  /// Bloc - Event Processing
  /////////////////////////////

  AppBloc()
      : super(AppBlocState(
            styleIndex: 0, actualInferencePath: "", modelIndex: 0)) {
    // Get style images
    var l = Iterable<int>.generate(25).toList();
    styleImages = l.map((e) => "assets/style_images/style$e.jpg").toList();

    on<ChangedStyleImageEvent>((event, emit) {
      // Notify the update style index
      emit(AppBlocState(
          styleIndex: event.styleIndex,
          actualInferencePath: state.actualInferencePath,
          modelIndex: state.modelIndex,
          runningInference: state.runningInference));

      // Check if none or custom image
      switch (event.styleIndex) {
        case 0:
          emit(AppBlocState(
              styleIndex: event.styleIndex,
              actualInferencePath: "",
              modelIndex: state.modelIndex));
          break;

        case 1:
          add(RunningInferenceEvent());
          _pickAndInference(event.sourceImagePath, state.model);
          break;

        default:
          add(RunningInferenceEvent());
          _inference(event.sourceImagePath, styleImages[event.styleIndex - 2],
              state.model);
          break;
      }
    });

    on<RunningInferenceEvent>((event, emit) {
      emit(AppBlocState(
          styleIndex: state.styleIndex,
          actualInferencePath: state.actualInferencePath,
          modelIndex: state.modelIndex,
          runningInference: true));
    });

    on<InferenceDoneEvent>((event, emit) {
      emit(AppBlocState(
          styleIndex: state.styleIndex,
          actualInferencePath: event.inferencePath,
          modelIndex: state.modelIndex,
          runningInference: false));
    });

    on<ChangedModelEvent>((event, emit) {
      state.model = StyleTransferer(models[event.modelIndex]);
      emit(AppBlocState(
          styleIndex: state.styleIndex,
          actualInferencePath: state.actualInferencePath,
          modelIndex: event.modelIndex));
    });
  }
}
