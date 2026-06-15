// import 'dart:convert';

// import 'package:prj_smart_style/features/preferences/domain/constants/preference_colors.dart';
// import 'package:prj_smart_style/features/preferences/domain/constants/preference_styles.dart';
// import 'package:prj_smart_style/features/wardrobe/domain/constants/wardrobe_categories.dart';
// import 'package:prj_smart_style/features/wardrobe/domain/entities/clothing_analysis_result_entity.dart';
// import 'package:prj_smart_style/features/wardrobe/domain/repositories/clothing_analysis_repository.dart';
// import 'package:prj_smart_style/shared/ai/data/services/gemini_service.dart';
// import 'package:prj_smart_style/shared/ai/domain/config/gemini_config.dart';

// class GeminiClothingAnalysisRepository implements ClothingAnalysisRepository {
//   final GeminiService geminiService;

//   const GeminiClothingAnalysisRepository({required this.geminiService});

//   @override
//   Future<ClothingAnalysisResultEntity> analyzeClothingImage({
//     required String imagePath,
//   }) async {
//     if (imagePath.trim().isEmpty) {
//       return const ClothingAnalysisResultEntity(
//         isValid: false,
//         errorMessage: "No image was selected.",
//       );
//     }

//     try {
//       final prompt = _buildPrompt();

//       final response = await geminiService.analyzeImage(
//         imagePath: imagePath,
//         prompt: prompt,
//         modelName: GeminiConfig.clothingAnalysisModel,
//       );

//       final json = _extractJson(response);

//       return _mapJsonToEntity(json);
//     } catch (e) {
//       return const ClothingAnalysisResultEntity(
//         isValid: false,
//         errorMessage:
//             "We couldn't analyze this image. Please try another clear photo of one clothing item.",
//       );
//     }
//   }

//   String _buildPrompt() {
//     final categoriesText = WardrobeCategories.all
//         .map((category) {
//           return "- ${category.id}: ${category.categoryName}";
//         })
//         .join("\n");

//     final stylesText = PreferenceStyles.all
//         .map((style) {
//           return "- ${style.id}: ${style.title}";
//         })
//         .join("\n");

//     final colorsText = PreferenceColors.all
//         .map((color) {
//           return "- ${color.id}: ${color.title}";
//         })
//         .join("\n");

//     return '''
// You are an AI clothing image analyzer for a mobile outfit recommendation app.

// Your task:
// 1. Decide if the image shows exactly one clear clothing item.
// 2. If the image is invalid, explain why.
// 3. If valid, classify the item using ONLY the allowed IDs below.
// 4. Generate a short, useful clothing description.

// Rules:
// - The image must show one individual clothing item.
// - Reject images with people wearing the item.
// - Reject images with multiple clothing items.
// - Reject blurry, dark, unclear, or unrelated images.
// - Do not invent IDs.
// - Use only the IDs listed below.
// - Return 1 to 3 style IDs.
// - Return 1 to 3 color IDs.
// - Put the strongest style match first.
// - Put the strongest color match first.
// - Return ONLY valid JSON.
// - Do not include markdown.
// - Do not include explanations outside JSON.

// Allowed wardrobe categories:
// $categoriesText

// Allowed style IDs:
// $stylesText

// Allowed color IDs:
// $colorsText

// Return this exact JSON shape:

// {
//   "isValid": true,
//   "errorMessage": null,
//   "wardrobeId": "one_allowed_wardrobe_id",
//   "styleIds": ["one_allowed_style_id", "optional_second_style_id"],
//   "colorIds": ["one_allowed_color_id", "optional_second_color_id"],
//   "description": "short clothing description"
// }

// If invalid, return:

// {
//   "isValid": false,
//   "errorMessage": "clear user-friendly reason",
//   "wardrobeId": null,
//   "styleIds": null,
//   "colorIds": null,
//   "description": null
// }
// ''';
//   }

//   Map<String, dynamic> _extractJson(String rawResponse) {
//     final cleaned = rawResponse
//         .replaceAll("```json", "")
//         .replaceAll("```", "")
//         .trim();

//     final decoded = jsonDecode(cleaned);

//     if (decoded is! Map<String, dynamic>) {
//       throw Exception("Invalid Gemini JSON response.");
//     }

//     return decoded;
//   }

//   ClothingAnalysisResultEntity _mapJsonToEntity(Map<String, dynamic> json) {
//     final isValid = json["isValid"] == true;

//     if (!isValid) {
//       return ClothingAnalysisResultEntity(
//         isValid: false,
//         errorMessage:
//             json["errorMessage"] as String? ??
//             "This image is not valid. Please upload one clear clothing item.",
//       );
//     }

//     final wardrobeId = json["wardrobeId"] as String?;
//     final styleIdsRaw = json["styleIds"];
//     final colorIdsRaw = json["colorIds"];
//     final description = json["description"] as String?;

//     final styleIds = _parseStringList(styleIdsRaw);
//     final colorIds = _parseStringList(colorIdsRaw);

//     final isWardrobeValid = WardrobeCategories.all.any((item) {
//       return item.id == wardrobeId;
//     });

//     final areStylesValid = _areIdsValid(
//       ids: styleIds,
//       allowedIds: PreferenceStyles.all.map((item) => item.id).toSet(),
//     );

//     final areColorsValid = _areIdsValid(
//       ids: colorIds,
//       allowedIds: PreferenceColors.all.map((item) => item.id).toSet(),
//     );

//     if (wardrobeId == null ||
//         description == null ||
//         description.trim().isEmpty ||
//         styleIds.isEmpty ||
//         colorIds.isEmpty ||
//         styleIds.length > 3 ||
//         colorIds.length > 3 ||
//         !isWardrobeValid ||
//         !areStylesValid ||
//         !areColorsValid) {
//       return const ClothingAnalysisResultEntity(
//         isValid: false,
//         errorMessage:
//             "The image could not be classified correctly. Please try a clearer photo.",
//       );
//     }

//     return ClothingAnalysisResultEntity(
//       isValid: true,
//       wardrobeId: wardrobeId,
//       styleIds: styleIds,
//       colorIds: colorIds,
//       description: description.trim(),
//     );
//   }

//   List<String> _parseStringList(dynamic value) {
//     if (value is! List) {
//       return [];
//     }

//     return value
//         .whereType<String>()
//         .map((item) {
//           return item.trim();
//         })
//         .where((item) {
//           return item.isNotEmpty;
//         })
//         .toSet()
//         .toList();
//   }

//   bool _areIdsValid({
//     required List<String> ids,
//     required Set<String> allowedIds,
//   }) {
//     if (ids.isEmpty) return false;

//     return ids.every((id) {
//       return allowedIds.contains(id);
//     });
//   }
// }
