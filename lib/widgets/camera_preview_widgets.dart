import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!CameraService.controller.value.isInitialized) {
      return const CircularProgressIndicator();
    }

    return CameraPreview(
      CameraService.controller,
    );
  }
}
