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

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloattingButton extends StatelessWidget {
  ValueNotifier<bool> isDialOpen;
  Function onCamera;
  Function onGallery;

  FloattingButton(
      {required this.isDialOpen,
      required this.onCamera,
      required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).colorScheme.primary, // primary swatch
      animatedIcon: AnimatedIcons.menu_arrow,
      label: const Text("New Inference"),
      renderOverlay: true,
      spacing: 10,
      spaceBetweenChildren: 10,
      switchLabelPosition: true,
      openCloseDial: isDialOpen,

      children: [
        SpeedDialChild(
          child: const Icon(Icons.camera_alt),
          label: "Camera",
          onTap: () => onCamera(),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_photo_alternate),
          label: "Gallery",
          onTap: () => onGallery(),
        ),
      ],
    );
  }
}
