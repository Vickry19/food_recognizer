import 'dart:io';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class FirebaseModelService {
  static Future<File?> downloadModel() async {
    try {
      final model = await FirebaseModelDownloader.instance.getModel(
        'food_classifier',
        FirebaseModelDownloadType.latestModel,
        FirebaseModelDownloadConditions(),
      );

      final File modelFile = model.file;

      print('Model downloaded at: ${modelFile.path}');

      return modelFile;
    } catch (e) {
      print('Failed to download model: $e');
      return null;
    }
  }
}
