part of 'app_bloc.dart';

class AppBlocState {
  int styleIndex = 0;
  String actualInferencePath = "";
  bool runningInference = false;
  StyleTransferer model = StyleTransferer("magenta", "fp16");

  AppBlocState(
      {required this.styleIndex,
      required this.actualInferencePath,
      this.runningInference = false});
}
