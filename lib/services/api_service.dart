import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/nutrition.dart';

class ApiService {
  static Future<Meal?> fetchMeal(String name) async {
    try {
      final url = "https://www.themealdb.com/api/json/v1/1/search.php?s=$name";

      final res = await http.get(Uri.parse(url));

      final data = jsonDecode(res.body);

      if (data["meals"] == null) return null;

      final meal = data["meals"][0];

      return Meal(
        name: meal["strMeal"],
        image: meal["strMealThumb"],
        ingredients: meal["strIngredient1"],
        instructions: meal["strInstructions"],
      );
    } catch (e) {
      return null;
    }
  }

  static Future<Nutrition> fetchNutrition(String food) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return Nutrition(
      calories: "250 kcal",
      carbs: "30 g",
      fat: "10 g",
      protein: "12 g",
      fiber: "4 g",
    );
  }
}
