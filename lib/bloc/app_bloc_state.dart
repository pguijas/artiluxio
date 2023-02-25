part of 'app_bloc.dart';

abstract class AppBlocState {
  bool isDarkMode = false;
  bool modelLoaded = false; // borrarlo
}

class AppBlocInitial extends AppBlocState {}

class AppBlocModelLoaded extends AppBlocState {
  final String model;
  AppBlocModelLoaded(this.model);
}

class AppBlocImgSelected extends AppBlocState {
  final XFile sourceImage;
  AppBlocImgSelected(this.sourceImage);
}

class AppBlocInferenceDone extends AppBlocImgSelected {
  final XFile outputImage;
  AppBlocInferenceDone(sourceImage, this.outputImage) : super(sourceImage);
}
