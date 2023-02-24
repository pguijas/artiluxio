import 'package:flutter/services.dart';
import 'package:image/image.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {

  final _predictorModel = "models/style_predict.tflite";
  final _transferModel = "models/style_transfer.tflite";
  final _outputFolder = "/storage/emulated/0/Download/";

  // TensorFlow Lite Interpreter object
  late Interpreter _predictorInterpreter;
  late Interpreter _transferInterpreter;

  Classifier() {
    // Load model when the classifier is initialized.
    _loadModel();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _predictorInterpreter = await Interpreter.fromAsset(_predictorModel);
    _transferInterpreter = await Interpreter.fromAsset(_transferModel);
    print('Interpreter loaded successfully');
  }

  Image _preprocess(Image image, height, width, saveAs) {

    // Resize to the model input shape
    Image transformed = copyResize(image, height: height, width: width);

    // Normalize between [0,1]
    transformed = transformed.convert(format: Format.float32);  // float32 for the models?

    // Save the image
    String outputFile = _outputFolder + saveAs;
    encodeImageFile(outputFile, transformed);

    return transformed;
  }

  void transfer(Image input, Image style) {
    print("Preprocessing inputs...");
    input = _preprocess(input, 384, 384, "input.jpg");
    style = _preprocess(style, 256, 256, "style.jpg");

    print("Allocating tensors...");
    _predictorInterpreter.allocateTensors();

    // if output tensor shape [1,1,1,100] and type is float32
    var output = List.filled(1*1*1*100, 0).reshape([1,1,1,100]);
  }

  List<double> classify(String rawText) {
    // tokenizeInputText returns List<List<double>>
    // of shape [1, 256].
    //List<List<double>> input = tokenizeInputText(rawText);

    // output of shape [1,2].
    var output = List<double>.filled(2, 0).reshape([1, 2]);

    // The run method will run inference and
    // store the resulting values in output.
   // _predictorInterpreter.run(input, output);

    return [output[0][0], output[0][1]];
  }

}