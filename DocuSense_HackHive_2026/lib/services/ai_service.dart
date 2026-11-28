import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // Replace with your actual API Key from Google AI Studio
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';

  static Future<String> simplifyText({
    required String category, // Medical, Legal, or Finance
    required String country,
    required String inputText,
  }) async {
    try {
      // Test if API key works.
      if (_apiKey.isEmpty) return 'Error: API Key is missing.';

      // Initialize the model
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
      );

      // Construct the prompt as requested
      final prompt = '''
        Please simplify and summarize the following $category document from $country to make it accessible for users with varying literacy levels and accessibility needs.

        RULES:
        - Use plain language at a 5th-grade reading level (approximately a 10-year-old’s comprehension).
        - Write short, clear sentences and organize information with bullet points.
        - Focus on actionable steps: clearly outline what the user should DO next.
        - Highlight and explain any legal, financial, or medical rights or obligations in clear, simple terms.
        - Make the content inclusive for users with reading, visual, or cognitive accessibility challenges.
        - Preserve essential information and context, but remove unnecessary jargon or complex phrasing.

        DOCUMENT TEXT:
      $inputText
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'Sorry, I couldn\'t process that text.';
    } catch (e) {
      // ignore: avoid_print
      print('FULL DEBUG ERROR: $e');
      return 'Error connecting to AI: $e';
    }
  }
}