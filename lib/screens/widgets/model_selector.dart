import 'package:flutter/material.dart';

class ModelSelector extends StatelessWidget {
  final bool isDarkMode;
  final List<String> models;

  const ModelSelector(
      {required this.isDarkMode, required this.models, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 20.0),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Select Model:",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),

        // dropbox to select the model
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          height: 40.0,
          width: 175.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: isDarkMode
                  ? const Color.fromARGB(20, 255, 255, 255)
                  : const Color.fromARGB(20, 0, 0, 0)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: models[0],
                  // obtain the value from the bloc
                  items: models
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                          )))
                      .toList(),
                  onChanged: (value) {
                    print(value);
                  }) // your Dropdown Widget here
              ),
        ),
      ],
    );
  }
}
