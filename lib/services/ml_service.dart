import 'dart:io';
import 'dart:isolate';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/prediction.dart';

class MLService {
  static late Interpreter interpreter;

  static Future loadModel(String path) async {
    interpreter = Interpreter.fromFile(File(path));
  }

  static Future<Prediction> predict(File image) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _predictIsolate,
      [receivePort.sendPort, image.path],
    );

    return await receivePort.first;
  }

  static void _predictIsolate(List data) async {
    final sendPort = data[0];
    final path = data[1];

    await Future.delayed(
      const Duration(seconds: 1),
    );

    sendPort.send(
      Prediction(
        label: "Pizza",
        confidence: 0.95,
      ),
    );
  }
}
