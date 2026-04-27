import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../services/ml_service.dart';
import '../services/firebase_service.dart';
import '../widgets/loading_widget.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;
  bool loading = false;
  bool modelReady = false;

  @override
  void initState() {
    super.initState();
    initModel();
  }

  Future<void> initModel() async {
    try {
      final path = await FirebaseService.downloadModel();

      await MLService.loadModel(path);

      setState(() {
        modelReady = true;
      });

      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future predict() async {
    if (image == null) return;

    if (!modelReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Model masih dimuat, tunggu sebentar"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final result = await MLService.predict(image!);

    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          image: image!,
          prediction: result,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food Recognizer")),
      body: loading
          ? const LoadingWidget()
          : Column(
              children: [
                const SizedBox(height: 20),
                if (image != null)
                  Image.file(
                    image!,
                    height: 200,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    image = await ImageService.pickCamera();
                    setState(() {});
                  },
                  child: const Text("Take Picture"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    image = await ImageService.pickGallery();
                    setState(() {});
                  },
                  child: const Text("Pick from Gallery"),
                ),
                ElevatedButton(
                  onPressed: modelReady ? predict : null,
                  child: Text(
                    modelReady ? "Predict" : "Loading Model...",
                  ),
                )
              ],
            ),
    );
  }
}
