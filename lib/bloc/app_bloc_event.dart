part of 'app_bloc.dart';

abstract class AppBlocEvent {}

/*
class AddModelEvent extends AppBlocEvent {
  final String model;
  AddModelEvent(this.model);
}

class ModelLoadedEvent extends AppBlocEvent {
  final String model;
  ModelLoadedEvent(this.model);
}
*/

class RunningInferenceEvent extends AppBlocEvent {}

class InferenceDoneEvent extends AppBlocEvent {
  final String inferencePath;
  InferenceDoneEvent(this.inferencePath);
}

class ChangedStyleImageEvent extends AppBlocEvent {
  final int styleIndex;
  String sourceImagePath;
  ChangedStyleImageEvent(
      {required this.sourceImagePath, required this.styleIndex});
}
