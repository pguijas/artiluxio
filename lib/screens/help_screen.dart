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

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          alignment: Alignment.center,
          height: 30,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //Body
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Our goal",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              left: 20.0, top: 20.0, bottom: 10.0, right: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "The purpose of this application is to transfer styles between images"
              "using the flutter sdk. We pursue this challenge because it has multiple "
              "uses in the real world, either for personal use for recreational purposes, "
              "to train reasoning from an early age or to help visually challenged people.",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "How to use",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              left: 20.0, top: 20.0, bottom: 10.0, right: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "The application has been designed in a minimalist and intuitive way for the user."
              "In the main menu the user can select a photo from the gallery or take it with the camera, "
              "then simply select or upload the desired model to be applied and that's it! \n"
              "After generation you can save the photo and share it :)",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),
        //Sustainability
        Container(
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Sustainability",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),

        //Why is this app sustainable?
        Container(
          margin: const EdgeInsets.only(
              left: 20.0, top: 20.0, bottom: 10.0, right: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "This app has been designed trying to reduce its energy consumption as much as possible."
              "We have not performed eternal training steps, but draw on the already pre-trained"
              "Magenta style transfer model. This is a very efficient model whose spend less than 5Mb."
              "We do not require cloud operations or data transfer over the network. We draw on efficient"
              " file formats and frameworks such as .tflite and C++. Also, a cache system is implemented "
              "to avoid performing unnecessary operations on images already transformed.",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Who we are?",
              style: TextStyle(
                fontSize: 40,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(
              left: 20.0, top: 20.0, bottom: 10.0, right: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Our team is formed by Angel Miguélez, Pedro Guijas and Elena Sánchez",
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
