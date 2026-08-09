import '../../../wardrobe/domain/entities/cloth_item_entity.dart';
import 'outfit_image_entity.dart';

class OutfitOutputEntity {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final List<ClothItemEntity> selectedClothingItems;
  final OutfitImageEntity? outfitImage;
  final String outfitInputId;

  const OutfitOutputEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.selectedClothingItems,
    this.outfitImage,
    required this.outfitInputId,
  });

  OutfitOutputEntity copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? description,
    List<ClothItemEntity>? selectedClothingItems,
    OutfitImageEntity? outfitImage,
    String? outfitInputId,
  }) {
    return OutfitOutputEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      selectedClothingItems:
          selectedClothingItems ?? this.selectedClothingItems,
      outfitImage: outfitImage ?? this.outfitImage,
      outfitInputId: outfitInputId ?? this.outfitInputId,
    );
  }
}
