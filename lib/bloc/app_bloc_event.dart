part of 'app_bloc.dart';

abstract class AppBlocEvent {}

/*
class AddModelEvent extends AppBlocEvent {
  final String model;
  AddModelEvent(this.model);
}
*/

class ModelLoadedEvent extends AppBlocEvent {
  final String model;
  ModelLoadedEvent(this.model);
}

class AddedSourceImageEvent extends AppBlocEvent {
  final XFile image;
  AddedSourceImageEvent(this.image);
}

class ChangedStyleImageEvent extends AppBlocEvent {
  final int styleIndex;
  String customStylePath;
  ChangedStyleImageEvent(
      {required this.styleIndex, required this.customStylePath});
}
