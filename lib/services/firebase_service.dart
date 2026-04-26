import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseService {
  static Future<String> downloadModel() async {
    final conditions = FirebaseModelDownloadConditions();

    final model = await FirebaseModelDownloader.instance.getModel(
      "food_model",
      FirebaseModelDownloadType.latestModel,
      conditions,
    );

    print("Model path: ${model.file.path}");

    return model.file.path;
  }
}
