import 'package:prj_smart_style/features/wardrobe/domain/entities/cloth_item_entity.dart';
import 'outfit_details_entity.dart';
import 'outfit_output_entity.dart';

class OutfitInputEntity {
  final String id;
  final OutfitDetailsEntity details;
  final List<ClothItemEntity> availableClothingItems;
  final List<OutfitOutputEntity> previousOutfitOutputs;

  const OutfitInputEntity({
    required this.id,
    required this.details,
    required this.availableClothingItems,
    this.previousOutfitOutputs = const [],
  });
}
