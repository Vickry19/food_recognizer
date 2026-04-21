import 'dart:io';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final File image;

  const DetailPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.file(image),
            const SizedBox(height: 10),
            const Text(
              'Ingredients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('- Coconut milk'),
            const Text('- Rice'),
            const Text('- Sambal'),
            const SizedBox(height: 10),
            const Text(
              'Instructions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Cook rice with coconut milk. Serve with sambal, egg, and cucumber.',
            ),
          ],
        ),
      ),
    );
  }
}
