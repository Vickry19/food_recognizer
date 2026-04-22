import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseService {
  static Future<String> downloadModel() async {
    final model = await FirebaseModelDownloader.instance.getModel(
      "food_model",
      FirebaseModelDownloadType.latestModel,
    );

    return model.file.path;
  }
}
