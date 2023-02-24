import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/app_bloc.dart';

/*
Main Screen Content:
  - App Bar (title and settings button)
  - Body
    - Last Inferences (laterally scrollable)
    - Load Model Button
  - Floating Button (new inference)
*/

class MainScreen extends StatelessWidget {
  final String title = "ArtiLuxio";
  final double imgSize = 125.0;

  const MainScreen({super.key});

  Widget itembluider(int i) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image(
        image: const AssetImage('assets/images/example.jpg'),
        height: imgSize,
        width: imgSize,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    List<String> models = BlocProvider.of<AppBloc>(context).models;

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
            height: 30,
          ),

          // set same color as background
          backgroundColor: isDarkMode ? Colors.black : Colors.white,

          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                print("settings button pressed");
              },
            ),
          ],
        ),

        // Body
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ),

            Container(
                margin:
                    const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
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
                itemCount: 10,
                itemBuilder: (_, i) => itembluider(i),
                separatorBuilder: (_, i) => const SizedBox(width: 10),
              ),
            ),

            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, top: 40.0, bottom: 10.0),
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
              width: 150.0,
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
            )
          ],
        ),
        /*
        Center(
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<AppBloc>(context).add(ModelLoadedEvent("model"));
            },
            child: const Text("Load Model"),
          ),
        ),
        */

        // Centered Floating Button
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print("floating button pressed");
            // Select an image
            //XFile image = ImagePicker().pickImage(source: ImageSource.gallery);
            //BlocProvider.of<AppBloc>(context).add(AddedSourceImageEvent());
          },
          label: const Text("New Inference"),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ));
    /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("floating button pressed");
          },
          child: const Icon(Icons.add),
        ));
        */
  }
}
