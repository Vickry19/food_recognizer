import 'dart:io';
import 'package:flutter/material.dart';
import 'detail_page.dart';

class ResultPage extends StatelessWidget {
  final File image;

  const ResultPage({super.key, required this.image});

  Map<String, dynamic> recognizeFood() {
    return {
      'name': 'Nasi Lemak',
      'confidence': '91.2%',
      'calories': '450 g',
      'carbs': '50 g',
      'protein': '10 g',
    };
  }

  @override
  Widget build(BuildContext context) {
    final result = recognizeFood();

    return Scaffold(
      appBar: AppBar(title: const Text('Result Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(image),
            const SizedBox(height: 10),
            Text(
              result['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Confidence: ${result['confidence']}'),
            const SizedBox(height: 10),
            const Text('Nutrition Facts'),
            Text('Calories: ${result['calories']}'),
            Text('Carbs: ${result['carbs']}'),
            Text('Protein: ${result['protein']}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(image: image),
                  ),
                );
              },
              child: const Text('View Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
