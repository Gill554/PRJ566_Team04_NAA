import '../../../preferences/domain/constants/preference_color_groups.dart';
import '../../../wardrobe/domain/constants/wardrobe_categories.dart';
import '../../../wardrobe/domain/entities/cloth_item_entity.dart';
import '../../../wardrobe/domain/repositories/wardrobe_repository.dart';
import '../entities/outfit_details_entity.dart';
import '../entities/outfit_input_entity.dart';
import '../entities/outfit_output_entity.dart';

class PrepareOutfitInputUseCase {
  final WardrobeRepository wardrobeRepository;

  const PrepareOutfitInputUseCase(this.wardrobeRepository);

  Future<OutfitInputEntity> call({
    required String userId,
    required OutfitDetailsEntity details,
    List<OutfitOutputEntity> previousOutfitOutputs = const [],
  }) async {
    final allUserClothes = await wardrobeRepository.getAllClothingItems(
      userId: userId,
    );

    final selectedStyleId = details.userProfilePreferences.preferencesStyle.id;
    final selectedColorId = details.userProfilePreferences.preferencesColor.id;

    final compatibleColorIds = PreferenceColorGroups.getCompatibleColorIds(
      selectedColorId,
    );

    final filteredClothes = allUserClothes.where((item) {
      final matchesStyle = item.aiStyleIds.contains(selectedStyleId);

      final matchesCompatibleColor = item.aiColorIds.any((colorId) {
        return compatibleColorIds.contains(colorId);
      });

      return item.userId == userId &&
          item.isImageAvailable &&
          matchesStyle &&
          matchesCompatibleColor;
    }).toList();

    _validateRequiredCategories(filteredClothes);

    return OutfitInputEntity(
      id: 'outfit_input_${DateTime.now().millisecondsSinceEpoch}',
      details: details,
      availableClothingItems: filteredClothes,
      previousOutfitOutputs: previousOutfitOutputs,
    );
  }

  void _validateRequiredCategories(List<ClothItemEntity> clothingItems) {
    if (clothingItems.isEmpty) {
      throw Exception(
        'No available clothing items match your selected style and compatible color preferences.',
      );
    }

    final categoryIds = clothingItems.map((item) {
      return item.wardrobeId;
    }).toSet();

    final missingCategories = <String>[];

    if (!categoryIds.contains(WardrobeCategories.tops.id)) {
      missingCategories.add('Tops');
    }

    if (!categoryIds.contains(WardrobeCategories.bottoms.id)) {
      missingCategories.add('Bottoms');
    }

    if (!categoryIds.contains(WardrobeCategories.footwear.id)) {
      missingCategories.add('Footwear');
    }

    if (missingCategories.isNotEmpty) {
      throw Exception(
        'Missing required clothing categories: '
        '${missingCategories.join(', ')}.',
      );
    }
  }
}
