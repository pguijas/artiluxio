import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path/path.dart';

class StyleTransferer {

  // System folder where to save the results
  final OUTPUT_FOLDER = "/storage/emulated/0/Download/";

  // Assets folder with the .tflite files
  final MODELS_FOLDER = "models/";

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

  StyleTransferer(String modelName, String precision) {
    _stylePredictor = MODELS_FOLDER + modelName + "_" + precision + "_prediction.tflite";
    _styleTransformer = MODELS_FOLDER + modelName + "_" + precision + "_transfer.tflite";
    _loadModel();
  }

  void _loadModel() async {
    _predictorInterpreter = await Interpreter.fromAsset(_stylePredictor);
    _transformerInterpreter = await Interpreter.fromAsset(_styleTransformer);
    print('Interpreters loaded successfully');

    // Save the input/output dimensions of both models to preprocess later the input images
    _inputImageSize = _transformerInterpreter.getInputTensor(0).shape[1];
    _styleImageSize = _predictorInterpreter.getInputTensor(0).shape[1];
    _featuresStylizedSize = _predictorInterpreter.getOutputTensor(0).shape[3];
    print("Predictor (input, output) resolution: ($_styleImageSize, $_featuresStylizedSize)");
    print("Transformer (input, output) resolution: ($_inputImageSize, $_inputImageSize)");
  }

  img.Image _preprocess(img.Image image, height, width) {

    // Resize to the a given (input) shape
    img.Image transformed = img.copyResize(image, height: height, width: width);

    // Normalize between [0,1]
    transformed = transformed.convert(format: img.Format.float32);

    return transformed;
  }

  Future<String> transfer(File inputFile, File styleFile) async {

    print("Reading images from system...");
    img.Image input = img.decodeImage(inputFile.readAsBytesSync())!;
    img.Image style = img.decodeImage(styleFile.readAsBytesSync())!;
    print("Input and style images read.");

    print("Preprocessing inputs...");
    img.Image processedInput = _preprocess(input, _inputImageSize, _inputImageSize);
    img.Image processedStyle = _preprocess(style, _styleImageSize, _styleImageSize);
    print("Preprocessing done.");

    var styleOutput = List.filled(_featuresStylizedSize, 0.0).reshape([1, 1, 1, _featuresStylizedSize]);
    print("Predicting style...");
    _predictorInterpreter.run(processedStyle.toUint8List(), styleOutput);
    print("Prediction finished.");

    var transferInputs = [processedInput.toUint8List(), styleOutput];
    var transferOutputs = Map<int, Object>();
    var outputData = List.filled(_inputImageSize * _inputImageSize * 3, 0.0)
        .reshape([1, _inputImageSize, _inputImageSize, 3]);
    transferOutputs[0] = outputData;

    print("Performing transformation...");
    _transformerInterpreter.runForMultipleInputs(transferInputs, transferOutputs);
    print("Transformation finished.");

    print("Converting transformation to image...");
    var outputImage = _convertArrayToImage(outputData, _inputImageSize);
    outputImage = img.copyResize(outputImage, width: input.width, height: input.height);
    print("Conversion finished.");

    String inputName = basename(inputFile.path).split(".")[0];
    String styleName = basename(styleFile.path).split(".")[0];
    String outputFile = OUTPUT_FOLDER + inputName + "_" + styleName + ".jpg";
    print("Saving results to $outputFile...");
    await img.encodeImageFile(outputFile, outputImage);

    return outputFile;
  }

  img.Image _convertArrayToImage(List<dynamic> imageArray, int inputSize) {
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

    img.Image newImage = img.Image.fromBytes(
        width: inputSize, height: inputSize, bytes: bytes.buffer);

    return newImage;
  }
}