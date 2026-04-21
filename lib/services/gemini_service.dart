import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'YOUR_API_KEY';

  static Future<String> getNutrition(String foodName) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final prompt =
        '''
Provide nutrition information for $foodName.
Include:
Calories
Carbohydrates
Fat
Fiber
Protein
''';

    final response = await model.generateContent([Content.text(prompt)]);

    return response.text ?? 'No data';
  }
}
