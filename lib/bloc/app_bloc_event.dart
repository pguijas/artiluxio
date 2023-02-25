part of 'app_bloc.dart';

abstract class AppBlocEvent {}

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

class ChangedModelEvent extends AppBlocEvent {
  final int modelIndex;
  ChangedModelEvent(this.modelIndex);
}
