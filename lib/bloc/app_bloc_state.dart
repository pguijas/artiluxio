part of 'app_bloc.dart';

class AppBlocState {
  int styleIndex = 0;
  String actualInferencePath = "";
  bool runningInference = false;
  int modelIndex = 0;
  StyleTransferer model = StyleTransferer("magenta_fp16");

  AppBlocState(
      {required this.styleIndex,
      required this.actualInferencePath,
      required this.modelIndex,
      this.runningInference = false});
}
