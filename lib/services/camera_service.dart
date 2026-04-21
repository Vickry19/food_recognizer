import 'package:camera/camera.dart';

class CameraService {
  static CameraController? controller;
  static List<CameraDescription>? cameras;

  static Future<void> initializeCamera() async {
    cameras = await availableCameras();

    controller = CameraController(
      cameras!.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
  }

  static Future<XFile?> takePicture() async {
    try {
      if (controller != null && controller!.value.isInitialized) {
        return await controller!.takePicture();
      }
    } catch (e) {
      print('Camera error: $e');
    }

    return null;
  }

  static void disposeCamera() {
    controller?.dispose();
    controller = null;
  }
}
