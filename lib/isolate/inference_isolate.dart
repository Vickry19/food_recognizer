import 'dart:isolate';
import '../services/tflite_service.dart';

class InferenceIsolate {
  static Future<List<double>> run(List<double> input) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(_isolateEntry, [receivePort.sendPort, input]);

    return await receivePort.first;
  }

  static void _isolateEntry(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<double> input = args[1];

    await TFLiteService.loadModel();

    var result = TFLiteService.runInference(input);

    sendPort.send(result);
  }
}
