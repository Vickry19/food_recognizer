import 'dart:io';
import 'package:flutter/material.dart';
import '../models/prediction.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../models/nutrition.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final Prediction prediction;

  const ResultScreen({
    super.key,
    required this.image,
    required this.prediction,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Meal? meal;
  Nutrition? nutrition;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    meal = await ApiService.fetchMeal(widget.prediction.label);

    nutrition = await ApiService.fetchNutrition(widget.prediction.label);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              widget.image,
              height: 200,
            ),
            Text(
              widget.prediction.label,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              "Confidence: ${(widget.prediction.confidence * 100).toStringAsFixed(2)}%",
            ),
            if (meal != null) ...[
              Image.network(meal!.image),
              Text(meal!.ingredients),
              Text(meal!.instructions),
            ],
            if (nutrition != null) ...[
              Text("Calories: ${nutrition!.calories}"),
              Text("Carbs: ${nutrition!.carbs}"),
              Text("Fat: ${nutrition!.fat}"),
              Text("Protein: ${nutrition!.protein}"),
              Text("Fiber: ${nutrition!.fiber}"),
            ]
          ],
        ),
      ),
    );
  }
}
