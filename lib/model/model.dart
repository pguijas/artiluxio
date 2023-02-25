import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class StyleTransferer {
  // Assets folder with the .tflite files
  final modeldFolder = "models/";

  // System folder where to save the results
  late String outputFolder;

  // tflite models to be used
  late final String _stylePredictor;
  late final String _styleTransformer;

  // TensorFlow Lite Interpreter object
  late final Interpreter _predictorInterpreter;
  late final Interpreter _transformerInterpreter;

  // Input and output sizes of each interpreter
  late final int _inputImageSize;
  late final int _styleImageSize;
  late final int _featuresStylizedSize;

  // Model loaded
  bool notLoaded = true;

  late String name;

  StyleTransferer(String name) {
    print("Loading model: $name");
    this.name = "magenta" + "_" + "fp16";
    _stylePredictor = modeldFolder + name + "_prediction.tflite";
    _styleTransformer = modeldFolder + name + "_transfer.tflite";
  }

  Future<void> loadModel() async {
    _predictorInterpreter = await Interpreter.fromAsset(_stylePredictor);
    _transformerInterpreter = await Interpreter.fromAsset(_styleTransformer);
    print('Interpreters loaded successfully');

    // Save the input/output dimensions of both models to preprocess later the input images
    _inputImageSize = _transformerInterpreter.getInputTensor(0).shape[1];
    _styleImageSize = _predictorInterpreter.getInputTensor(0).shape[1];
    _featuresStylizedSize = _predictorInterpreter.getOutputTensor(0).shape[3];
    print(
        "Predictor (input, output) resolution: ($_styleImageSize, $_featuresStylizedSize)");
    print(
        "Transformer (input, output) resolution: ($_inputImageSize, $_inputImageSize)");

    outputFolder =
        (await getApplicationDocumentsDirectory()).path + "/inferences/";

    notLoaded = false;
  }

  img.Image _preprocess(img.Image image, height, width) {
    // Resize to the a given (input) shape
    img.Image transformed = img.copyResize(image, height: height, width: width);

    // Normalize between [0,1]
    transformed = transformed.convert(format: img.Format.float32);

    return transformed;
  }

  Future<String> transfer(File inputFile, File styleFile) async {
    if (notLoaded) {
      print("Model not loaded, llamandolo antes de cargarlo");
    }
    print("------Name: $name");
    //if (name =)

    String inputName = basename(inputFile.path).split(".")[0];
    String styleName = basename(styleFile.path).split(".")[0];
    String outputFile =
        outputFolder + inputName + "_" + styleName + "_" + name + ".jpg";

    // Cache: do not compute again the result if it already exists in the output folder
    if (await File(outputFile).exists()) {
      print("Restoring output from previous inference.");
      return outputFile;
    }

    print("Reading images from system...");
    img.Image? style;
    if (!await styleFile.exists()) {
      ByteData styleBytes = await rootBundle.load(styleFile.path);
      Uint8List styleUint8 = styleBytes.buffer.asUint8List();
      style = img.decodeImage(styleUint8)!;
    } else {
      style = img.decodeImage(styleFile.readAsBytesSync())!;
    }
    img.Image input = img.decodeImage(inputFile.readAsBytesSync())!;
    print("Input and style images read.");

    print("Preprocessing inputs...");
    img.Image processedInput =
        _preprocess(input, _inputImageSize, _inputImageSize);
    img.Image processedStyle =
        _preprocess(style, _styleImageSize, _styleImageSize);
    print("Preprocessing done.");

    var styleOutput = List.filled(_featuresStylizedSize, 0.0)
        .reshape([1, 1, 1, _featuresStylizedSize]);
    print("Predicting style...");
    _predictorInterpreter.run(processedStyle.toUint8List(), styleOutput);
    print("Prediction finished.");

    var transferInputs = [processedInput.toUint8List(), styleOutput];
    var transferOutputs = Map<int, Object>();
    var outputData = List.filled(_inputImageSize * _inputImageSize * 3, 0.0)
        .reshape([1, _inputImageSize, _inputImageSize, 3]);
    transferOutputs[0] = outputData;

    print("Performing transformation...");
    _transformerInterpreter.runForMultipleInputs(
        transferInputs, transferOutputs);
    print("Transformation finished.");

    print("Converting transformation to image...");
    var outputImage = _convertArrayToImage(outputData, _inputImageSize);
    outputImage =
        img.copyResize(outputImage, width: input.width, height: input.height);
    print("Conversion finished.");

    print("Saving results to $outputFile...");
    await img.encodeImageFile(outputFile, outputImage);

    return outputFile;
  }

  img.Image _convertArrayToImage(List<dynamic> imageArray, int inputSize) {
    Uint8List bytes =
        Uint8List.fromList(List.filled(inputSize * inputSize * 3, 0));

    for (int x = 0; x < inputSize; x++) {
      for (int y = 0; y < inputSize; y++) {
        int pixelIndex = (x * inputSize + y) * 3;
        bytes[pixelIndex] = (imageArray[0][x][y][0] * 255).toInt();
        bytes[pixelIndex + 1] = (imageArray[0][x][y][1] * 255).toInt();
        bytes[pixelIndex + 2] = (imageArray[0][x][y][2] * 255).toInt();
      }
    }

    img.Image newImage = img.Image.fromBytes(
        width: inputSize, height: inputSize, bytes: bytes.buffer);

    return newImage;
  }
}
