import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';

import '../../domain/config/gemini_config.dart';

class GeminiService {
  Future<String> generateText({
    required String prompt,
    String modelName = GeminiConfig.outfitGenerationModel,
  }) async {
    final model = FirebaseAI.googleAI().generativeModel(model: modelName);

    final response = await model.generateContent([Content.text(prompt)]);

    final text = response.text;

    if (text == null || text.trim().isEmpty) {
      throw Exception('Gemini returned an empty response.');
    }

    return text.trim();
  }

  Future<String> analyzeImage({
    required String imagePath,
    required String prompt,
    String modelName = GeminiConfig.clothingAnalysisModel,
  }) async {
    final file = File(imagePath);

    if (!await file.exists()) {
      throw Exception('Image file was not found.');
    }

    final imageBytes = await file.readAsBytes();

    final model = FirebaseAI.googleAI().generativeModel(model: modelName);

    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        InlineDataPart('image/jpeg', imageBytes),
      ]),
    ]);

    final text = response.text;

    if (text == null || text.trim().isEmpty) {
      throw Exception('Gemini returned an empty response.');
    }

    return text.trim();
  }
}
