import 'dart:convert';
import 'package:http/http.dart' as http;

class MealDBService {
  static Future<Map<String, dynamic>?> searchMeal(String mealName) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$mealName',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['meals'] != null) {
        return data['meals'][0];
      }
    }

    return null;
  }
}
