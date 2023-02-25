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
