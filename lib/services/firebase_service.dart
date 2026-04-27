import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseService {
  static Future<String> downloadModel() async {
    try {
      print("Downloading model: food_model");

      final model = await FirebaseModelDownloader.instance.getModel(
        "food_model",
        FirebaseModelDownloadType.latestModel,
      );

      print("Model downloaded successfully");
      print("Model path: ${model.file.path}");

      return model.file.path;
    } catch (e) {
      print("Download model error: $e");
      rethrow;
    }
  }
}
