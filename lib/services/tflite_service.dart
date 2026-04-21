import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  static Interpreter? _interpreter;

  static Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('model.tflite');
      print('Model loaded');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  static List<double> runInference(List<double> input) {
    var output = List.filled(10, 0.0).reshape([1, 10]);

    _interpreter?.run(input.reshape([1, input.length]), output);

    return output[0];
  }
}
