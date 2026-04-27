import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../models/prediction.dart';

class MLService {
  static late Interpreter interpreter;
  static List<String> labels = [];
  static bool isModelLoaded = false;

  // LOAD MODEL
  static Future<void> loadModel(String path) async {
    try {
      interpreter = Interpreter.fromFile(File(path));

      final labelData = await rootBundle.loadString("assets/labels.txt");

      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();

      isModelLoaded = true;

      print("Model loaded successfully");
      print("Labels loaded: ${labels.length}");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // PREDICT
  static Future<Prediction> predict(File image) async {
    if (!isModelLoaded) {
      throw Exception("Model belum di-load");
    }

    final receivePort = ReceivePort();

    await Isolate.spawn(
      _predictIsolate,
      [
        receivePort.sendPort,
        image.path,
        interpreter.address,
        labels,
      ],
    );

    final result = await receivePort.first;

    return result as Prediction;
  }

  // ISOLATE
  static void _predictIsolate(List data) async {
    // DECLARE sendPort FIRST (fix error)
    final SendPort sendPort = data[0] as SendPort;

    try {
      final String path = data[1] as String;
      final interpreterAddress = data[2];
      final List<String> labels = data[3];

      final interpreter = Interpreter.fromAddress(interpreterAddress);

      final bytes = await File(path).readAsBytes();

      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception("Image decode failed");
      }

      // Resize image
      img.Image resized = img.copyResize(
        image,
        width: 224,
        height: 224,
      );

      // Input tensor
      var input = List.generate(
        1,
        (_) => List.generate(
          224,
          (_) => List.generate(
            224,
            (_) => List.filled(3, 0.0),
          ),
        ),
      );

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resized.getPixel(x, y);

          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }

      // Output tensor
      var output = List.generate(
        1,
        (_) => List.filled(labels.length, 0.0),
      );

      interpreter.run(input, output);

      int index = 0;
      double confidence = 0;

      for (int i = 0; i < labels.length; i++) {
        if (output[0][i] > confidence) {
          confidence = output[0][i];
          index = i;
        }
      }

      print("Prediction index: $index");
      print("Prediction label: ${labels[index]}");
      print("Confidence: $confidence");

      sendPort.send(
        Prediction(
          label: labels[index],
          confidence: confidence,
        ),
      );
    } catch (e) {
      print("Prediction error: $e");

      sendPort.send(
        Prediction(
          label: "Error",
          confidence: 0.0,
        ),
      );
    }
  }
}
