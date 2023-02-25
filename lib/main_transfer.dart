import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'style_transferer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();

  File? _inputImage;
  File? _styleImage;
  File? _outputImage;

  StyleTransferer? styleTransferer;
  String _currentModel = "magenta";
  String _currentPrecision = "fp16";

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _loadModel() async {
    styleTransferer = StyleTransferer(_currentModel, _currentPrecision);
  }

  void _changeModel() async {
    _currentPrecision = _currentPrecision == "int8" ? "fp16" : "int8";
    print("Changed model to $_currentModel ($_currentPrecision)");
    _loadModel();
  }

  void _getInputImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _inputImage = File(pickedFile!.path);
      _outputImage = null;
    });
  }

  void _getStyleImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _styleImage = File(pickedFile!.path);
      _outputImage = null;
    });
  }

  void _predict() async {

    if (_inputImage == null) {
      print("Select an input image.");
      return;
    }

    if (_styleImage == null) {
      print("Select an style image.");
      return;
    }

    if (styleTransferer == null) {
      print("Select a model.");
      return;
    }

    String output = await styleTransferer!.transfer(_inputImage!, _styleImage!);
    setState(() {
      _inputImage = null;
      _styleImage = null;
      _outputImage = File(output);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: _inputImage == null
                  ? Text('No input image selected.')
                  : Container(
                      constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 2),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Image.file(_inputImage!),
              ),
            ),
            Center(
              child: _styleImage == null
                  ? Text('No style image selected.')
                  : Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Image.file(_styleImage!),
              ),
            ),
            Center(
              child: _outputImage == null
                  ? Text('No output image.')
                  : Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height / 2),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Image.file(_outputImage!),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getInputImage,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _getStyleImage,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _predict,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _changeModel,
            tooltip: 'Increment',
            child: const Icon(Icons.adb),
          ),
        ]
      )

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
