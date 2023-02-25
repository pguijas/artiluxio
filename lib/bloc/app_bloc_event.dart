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
