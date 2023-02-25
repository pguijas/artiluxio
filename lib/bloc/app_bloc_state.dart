part of 'app_bloc.dart';

class AppBlocState {
  int styleIndex = 0;
  String customStylePath = "";
  String actualInferencePath = "";

  AppBlocState(
      {required this.styleIndex,
      required this.customStylePath,
      required this.actualInferencePath});
}
