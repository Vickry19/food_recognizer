import 'package:camera/camera.dart';

class CameraService {
  static late CameraController controller;

  static Future init() async {
    final cameras = await availableCameras();

    controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );

    await controller.initialize();
  }

  static Future<XFile> takePicture() async {
    return controller.takePicture();
  }
}
