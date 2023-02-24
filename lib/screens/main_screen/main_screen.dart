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
  const MainScreen({super.key});

  /*
  Widget itembluider(int i) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: const Image(
        image: AssetImage('assets/images/example.jpg'),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      ),
    );
  }
  */

  Widget itembluider(int i) {
    return Container(
        margin: EdgeInsets.all(30), width: 100, height: 30, color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                print("settings button pressed");
              },
            ),
          ],
        ),

        // Body
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 30.0, left: 0.0),
            child: Text(
              "Hello!",
              style: TextStyle(
                fontSize: 50,
                fontFamily: "Roboto",
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 15.0),
            child: Text(
              "Last Inferences:",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Roboto",
              ),
            ),
          ),
          // Last Inferences Scrollable

          SizedBox(
            height: 10,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (_, i) => itembluider(i),
              separatorBuilder: (_, i) => const SizedBox(width: 10),
            ),
          )
        ]),

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
