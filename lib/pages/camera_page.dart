import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    controller = CameraController(cameras.first, ResolutionPreset.medium);

    await controller!.initialize();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Feed')),
      body: CameraPreview(controller!),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await controller!.takePicture();

          Navigator.pop(context, image.path);
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
