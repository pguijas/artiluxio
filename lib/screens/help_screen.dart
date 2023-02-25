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
              ":P",
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
              "Our team is formed by Angel pepo and elena",
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
