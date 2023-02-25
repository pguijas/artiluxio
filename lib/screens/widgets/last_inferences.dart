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

class LastInferences extends StatelessWidget {
  final double imgSize;
  final Widget Function(BuildContext, int, List<String>) itemBuilder;
  final List<String> images;

  const LastInferences(
      {required this.imgSize,
      required this.itemBuilder,
      required this.images,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Your last Inferences:",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w300),
              ),
            )),

        // Last Inferences Scrollable
        SizedBox(
          height: imgSize,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(0),
            itemCount: images.length,
            itemBuilder: (_, i) => itemBuilder(context, i, images),
            separatorBuilder: (_, i) => const SizedBox(width: 10),
          ),
        ),
      ],
    );
  }
}
