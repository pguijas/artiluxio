import 'dart:typed_data';
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
    transformed = transformed.convert(format: Format.float32);

    // Save the image
    String outputFile = _outputFolder + saveAs;
    encodeImageFile(outputFile, transformed);

    return transformed;
  }

  Future<void> transfer(Image input, Image style) async {
    print("Preprocessing inputs...");
    Image processedInput = _preprocess(input, 384, 384, "input.jpg");
    Image processedStyle = _preprocess(style, 256, 256, "style.jpg");

    final inputShape = _predictorInterpreter.getInputTensor(0).shape;
    final outputShape = _predictorInterpreter.getOutputTensor(0).shape;
    print(inputShape);  // [1, 256, 256, 3]
    print(outputShape);  // [1, 1, 1, 100]

    var outputStyle = List.filled(1*1*1*100, 0).reshape([1,1,1,100]);
    var styleBottleneck = [
      [
        [List.generate(100, (index) => 0.0)]
      ]
    ];
    print("Predicting style...");
    _predictorInterpreter.run(processedStyle.toUint8List(), styleBottleneck);
    print("Prediction finished");

    // inputs: [1, 384, 384, 3] (0) and [1, 1, 1, 100] (1)
    // output: [1, 384, 384, 3] (0)

    var transferInputs = [processedInput.toUint8List(), styleBottleneck];

    var outputTransformation = List.filled(1*384*384*3, 0.0).reshape([1,384,384,3]);
    print(outputTransformation.shape);
    print(outputTransformation);

    var mapOutputTransformation = Map<int, dynamic>();
    mapOutputTransformation[0] = outputTransformation;

    var outputsForStyleTransfer = Map<int, Object>();
    // stylized_image 1 384 384 3
    var outputImageData = [
      List.generate(
        384,
            (index) => List.generate(
          384,
              (index) => List.generate(3, (index) => 0.0),
        ),
      ),
    ];
    outputsForStyleTransfer[0] = outputImageData;

    print("Prediction transformation...");
    _transferInterpreter.runForMultipleInputs(transferInputs, outputsForStyleTransfer);
    print("Prediciton finished");

    print("Converting prediction to image...");
    var outputImage = _convertArrayToImage(outputImageData, 384);
    outputImage = copyResize(outputImage, width: input.width, height: input.height);
    print("Conversion finished");

    print("Saving output...");
    String outputFile = _outputFolder + "output.jpg";
    bool b = await encodeImageFile(outputFile, outputImage);
    if (b) {
      print("Output saved successfully");
    } else {
      print("Could not save the output");
    }

  }

  Image _convertArrayToImage(List<List<List<List<double>>>> imageArray, int inputSize) {
    Uint8List bytes = Uint8List.fromList(
        List.filled(inputSize * inputSize * 3, 0));

    for (int x = 0; x < inputSize; x++) {
      for (int y = 0; y < inputSize; y++) {
        int pixelIndex = (x * inputSize + y) * 3;
        bytes[pixelIndex] = (imageArray[0][x][y][0] * 255).toInt();
        bytes[pixelIndex + 1] = (imageArray[0][x][y][1] * 255).toInt();
        bytes[pixelIndex + 2] = (imageArray[0][x][y][2] * 255).toInt();
      }
    }

    Image newImage = Image.fromBytes(
        width: inputSize, height: inputSize, bytes: bytes.buffer);

    return newImage;
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