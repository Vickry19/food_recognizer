import 'package:flutter/material.dart';
import 'pages/photo_picker_page.dart';

void main() {
  runApp(const FoodRecognizerApp());
}

class FoodRecognizerApp extends StatelessWidget {
  const FoodRecognizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Recognizer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PhotoPickerPage(),
    );
  }
}
