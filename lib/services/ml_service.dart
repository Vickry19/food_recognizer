import 'dart:io';
import 'dart:isolate';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/prediction.dart';

class MLService {
  static late Interpreter interpreter;
  static List<String> labels = [];

  static Future loadModel(String path) async {
    interpreter = Interpreter.fromFile(File(path));

    final labelFile = File("assets/labels.txt");
    labels = await labelFile.readAsLines();
  }

  static Future<Prediction> predict(File image) async {
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

    return await receivePort.first;
  }

  static void _predictIsolate(List data) async {
    final sendPort = data[0];
    final path = data[1];
    final interpreterAddress = data[2];
    final labels = data[3];

    final interpreter = Interpreter.fromAddress(interpreterAddress);

    final bytes = await File(path).readAsBytes();

    img.Image? image = img.decodeImage(bytes);

    img.Image resized = img.copyResize(
      image!,
      width: 224,
      height: 224,
    );

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

    sendPort.send(
      Prediction(
        label: labels[index],
        confidence: confidence,
      ),
    );
  }
}
