import 'dart:convert';

import '../../../preferences/domain/constants/preference_colors.dart';
import '../../../preferences/domain/constants/preference_styles.dart';
import '../../../wardrobe/domain/constants/wardrobe_categories.dart';
import '../../../wardrobe/domain/entities/cloth_item_entity.dart';
import '../../domain/entities/outfit_input_entity.dart';
import '../../domain/entities/outfit_output_entity.dart';
import '../../domain/repositories/outfit_repository.dart';
import '../../../../shared/ai/data/services/gemini_service.dart';
import '../../../../shared/ai/domain/config/gemini_config.dart';

class GeminiOutfitRepository implements OutfitRepository {
  final GeminiService geminiService;

  const GeminiOutfitRepository({required this.geminiService});

  @override
  Future<List<OutfitOutputEntity>> generateOutfitRecommendations({
    required OutfitInputEntity input,
  }) async {
    return _generateOutfits(
      input: input,
      previousOutfits: input.previousOutfitOutputs,
    );
  }

  @override
  Future<List<OutfitOutputEntity>> regenerateOutfitRecommendations({
    required OutfitInputEntity input,
  }) async {
    return _generateOutfits(
      input: input,
      previousOutfits: input.previousOutfitOutputs,
    );
  }

  Future<List<OutfitOutputEntity>> _generateOutfits({
    required OutfitInputEntity input,
    required List<OutfitOutputEntity> previousOutfits,
  }) async {
    try {
      final prompt = _buildPrompt(
        input: input,
        previousOutfits: previousOutfits,
      );

      final response = await geminiService.generateText(
        prompt: prompt,
        modelName: GeminiConfig.outfitGenerationModel,
      );

      final json = _extractJson(response);

      return _mapJsonToOutfits(json: json, input: input);
    } catch (e) {
      throw Exception(
        "We couldn't generate outfit recommendations. Please try again. $e",
      );
    }
  }

  String _buildPrompt({
    required OutfitInputEntity input,
    required List<OutfitOutputEntity> previousOutfits,
  }) {
    final categoriesText = WardrobeCategories.all
        .map((category) {
          return "- ${category.id}: ${category.categoryName}";
        })
        .join("\n");

    final stylesText = PreferenceStyles.all
        .map((style) {
          return "- ${style.id}: ${style.title}";
        })
        .join("\n");

    final colorsText = PreferenceColors.all
        .map((color) {
          return "- ${color.id}: ${color.title}";
        })
        .join("\n");

    final availableItemsText = input.availableClothingItems
        .map((item) {
          return '''
- id: ${item.id}
  wardrobeId: ${item.wardrobeId}
  styleIds: ${item.aiStyleIds.join(", ")}
  colorIds: ${item.aiColorIds.join(", ")}
  description: ${item.aiDescription}
''';
        })
        .join("\n");

    final topsItemIds = input.availableClothingItems
        .where((item) {
          return item.wardrobeId == WardrobeCategories.tops.id;
        })
        .map((item) {
          return item.id;
        })
        .join(", ");

    final bottomsItemIds = input.availableClothingItems
        .where((item) {
          return item.wardrobeId == WardrobeCategories.bottoms.id;
        })
        .map((item) {
          return item.id;
        })
        .join(", ");

    final footwearItemIds = input.availableClothingItems
        .where((item) {
          return item.wardrobeId == WardrobeCategories.footwear.id;
        })
        .map((item) {
          return item.id;
        })
        .join(", ");

    final outerwearItemIds = input.availableClothingItems
        .where((item) {
          return item.wardrobeId == WardrobeCategories.outerwear.id;
        })
        .map((item) {
          return item.id;
        })
        .join(", ");

    final accessoriesItemIds = input.availableClothingItems
        .where((item) {
          return item.wardrobeId == WardrobeCategories.accessories.id;
        })
        .map((item) {
          return item.id;
        })
        .join(", ");

    final previousOutfitsText = previousOutfits.isEmpty
        ? "No previous outfits."
        : previousOutfits
              .map((outfit) {
                final itemIds = outfit.selectedClothingItems
                    .map((item) => item.id)
                    .join(", ");

                return '''
- outfitId: ${outfit.id}
  title: ${outfit.title}
  selectedClothingItemIds: [$itemIds]
''';
              })
              .join("\n");

    final selectedStyle = input.details.userProfilePreferences.preferencesStyle;
    final selectedColor = input.details.userProfilePreferences.preferencesColor;

    return '''
You are SmartStyle, an AI outfit recommendation assistant.

Your task:
Generate exactly TWO outfit recommendations using only the provided clothing item IDs.

User context:
- Occasion: ${input.details.occasion}
- Weather: ${input.details.weather}
- Preferred style: ${selectedStyle.title}
- Preferred style prompt: ${selectedStyle.prompt}
- Preferred color palette: ${selectedColor.title}
- Preferred color prompt: ${selectedColor.prompt}

Allowed wardrobe categories:
$categoriesText

Allowed style IDs:
$stylesText

Allowed color IDs:
$colorsText

Available clothing items:
$availableItemsText

Required category item IDs:
- Tops IDs: $topsItemIds
- Bottoms IDs: $bottomsItemIds
- Footwear IDs: $footwearItemIds

Optional category item IDs:
- Outerwear IDs: $outerwearItemIds
- Accessories IDs: $accessoriesItemIds

Previous outfits that should NOT be repeated:
$previousOutfitsText

Rules:
- Return exactly 2 outfits.
- Use ONLY clothing item IDs from the available clothing items list.
- Do not invent item IDs.
- Do not alter, combine, shorten, extend, or rewrite item IDs.
- Copy item IDs exactly as written in the available clothing items list.
- Each clothing item may have multiple styleIds and colorIds.
- Prefer items whose styleIds include the user's preferred style.
- Prefer items whose colorIds include the user's preferred color palette.
- Use secondary styleIds/colorIds as valid matches, but prioritize the first IDs when possible.
- Every outfit MUST include exactly one ID from Tops IDs.
- Every outfit MUST include exactly one ID from Bottoms IDs.
- Every outfit MUST include exactly one ID from Footwear IDs.
- Each outfit may optionally include:
  - one ID from Outerwear IDs
  - one or more IDs from Accessories IDs
- Do not include more than one Tops item.
- Do not include more than one Bottoms item.
- Do not include more than one Footwear item.
- Do not include more than one Outerwear item.
- Never select two Bottoms items in the same outfit.
- Never select two Footwear items in the same outfit.
- Never omit Tops.
- Never generate an outfit without one Tops item, one Bottoms item, and one Footwear item.
- If there is only one available Tops item, reuse the same Tops item in both outfits.
- If there is only one available Footwear item, you may reuse the same Footwear item in both outfits.
- Prefer changing Bottoms and Footwear between the two outfits when possible.
- Do not repeat the exact same combination from previous outfits.
- The two outfits must not use the exact same full combination.
- Do not assume missing items.
- Do not mention clothing items that are not included in selectedClothingItemIds.
- Outfit titles must be short and user-friendly.
- Outfit descriptions must explain why the outfit fits the occasion, weather, style, and color preference.
- Return ONLY valid JSON.
- Do not include markdown.
- Do not include explanations outside JSON.

Return this exact JSON shape:

{
  "outfits": [
    {
      "title": "Short outfit title",
      "description": "Useful explanation for the user.",
      "selectedClothingItemIds": [
        "exact_tops_id_from_list",
        "exact_bottoms_id_from_list",
        "exact_footwear_id_from_list"
      ]
    },
    {
      "title": "Short outfit title",
      "description": "Useful explanation for the user.",
      "selectedClothingItemIds": [
        "exact_tops_id_from_list",
        "exact_bottoms_id_from_list",
        "exact_footwear_id_from_list"
      ]
    }
  ]
}
''';
  }

  Map<String, dynamic> _extractJson(String rawResponse) {
    final cleaned = rawResponse
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    final decoded = jsonDecode(cleaned);

    if (decoded is! Map<String, dynamic>) {
      throw Exception("Invalid Gemini JSON response.");
    }

    return decoded;
  }

  List<OutfitOutputEntity> _mapJsonToOutfits({
    required Map<String, dynamic> json,
    required OutfitInputEntity input,
  }) {
    final outfitsJson = json["outfits"];

    if (outfitsJson is! List || outfitsJson.length != 2) {
      throw Exception("Gemini must return exactly two outfits.");
    }

    final availableItemsById = {
      for (final item in input.availableClothingItems) item.id: item,
    };

    final mappedOutfits = <OutfitOutputEntity>[];

    for (int index = 0; index < outfitsJson.length; index++) {
      final outfitJson = outfitsJson[index];

      if (outfitJson is! Map<String, dynamic>) {
        throw Exception("Invalid outfit JSON.");
      }

      final title = outfitJson["title"] as String?;
      final description = outfitJson["description"] as String?;
      final selectedIds = outfitJson["selectedClothingItemIds"];

      if (title == null ||
          title.trim().isEmpty ||
          description == null ||
          description.trim().isEmpty ||
          selectedIds is! List) {
        throw Exception("Invalid outfit fields.");
      }

      final selectedItems = _mapSelectedIdsToItems(
        selectedIds: selectedIds,
        availableItemsById: availableItemsById,
      );

      _validateOutfitCategories(selectedItems);

      mappedOutfits.add(
        OutfitOutputEntity(
          id: 'outfit_${DateTime.now().millisecondsSinceEpoch}_$index',
          date: DateTime.now(),
          title: title.trim(),
          description: description.trim(),
          selectedClothingItems: selectedItems,
          outfitInputId: input.id,
        ),
      );
    }

    _validateDifferentCombinations(mappedOutfits);

    return mappedOutfits;
  }

  List<ClothItemEntity> _mapSelectedIdsToItems({
    required List<dynamic> selectedIds,
    required Map<String, ClothItemEntity> availableItemsById,
  }) {
    final selectedItems = <ClothItemEntity>[];

    for (final id in selectedIds) {
      if (id is! String) {
        throw Exception("Invalid clothing item id.");
      }

      final item = availableItemsById[id];

      if (item == null) {
        throw Exception("Gemini selected an unavailable clothing item: $id");
      }

      selectedItems.add(item);
    }

    return selectedItems;
  }

  void _validateOutfitCategories(List<ClothItemEntity> items) {
    final categoryIds = items.map((item) => item.wardrobeId).toSet();

    final hasTops = categoryIds.contains(WardrobeCategories.tops.id);
    final hasBottoms = categoryIds.contains(WardrobeCategories.bottoms.id);
    final hasFootwear = categoryIds.contains(WardrobeCategories.footwear.id);

    if (!hasTops || !hasBottoms || !hasFootwear) {
      throw Exception(
        "Generated outfit is missing required clothing categories.",
      );
    }

    final topsCount = items.where((item) {
      return item.wardrobeId == WardrobeCategories.tops.id;
    }).length;

    final bottomsCount = items.where((item) {
      return item.wardrobeId == WardrobeCategories.bottoms.id;
    }).length;

    final footwearCount = items.where((item) {
      return item.wardrobeId == WardrobeCategories.footwear.id;
    }).length;

    final outerwearCount = items.where((item) {
      return item.wardrobeId == WardrobeCategories.outerwear.id;
    }).length;

    if (topsCount > 1 ||
        bottomsCount > 1 ||
        footwearCount > 1 ||
        outerwearCount > 1) {
      throw Exception(
        "Generated outfit contains too many items from the same required category.",
      );
    }
  }

  void _validateDifferentCombinations(List<OutfitOutputEntity> outfits) {
    final combinations = outfits.map((outfit) {
      final ids = outfit.selectedClothingItems.map((item) => item.id).toList()
        ..sort();

      return ids.join("|");
    }).toSet();

    if (combinations.length != outfits.length) {
      throw Exception("Gemini generated duplicate outfits.");
    }
  }
}
