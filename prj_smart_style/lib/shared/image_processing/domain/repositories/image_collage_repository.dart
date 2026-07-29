import '../../../../features/wardrobe/domain/entities/cloth_item_entity.dart';

abstract class ImageCollageRepository {
  Future<String> createCollage({required List<ClothItemEntity> clothingItems});
}
