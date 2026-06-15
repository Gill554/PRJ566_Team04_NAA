import '../entities/cloth_item_entity.dart';
import '../entities/wardrobe_entity.dart';

abstract class WardrobeRepository {
  Future<List<WardrobeEntity>> getWardrobeCategories();

  Future<List<ClothItemEntity>> getClothingItemsByCategory({
    required String userId,
    required String wardrobeId,
  });

  Future<List<ClothItemEntity>> getAllClothingItems({required String userId});

  Future<ClothItemEntity> addClothingItem({required ClothItemEntity clothItem});

  Future<void> deleteClothingItem({
    required String userId,
    required String clothItemId,
  });
}
