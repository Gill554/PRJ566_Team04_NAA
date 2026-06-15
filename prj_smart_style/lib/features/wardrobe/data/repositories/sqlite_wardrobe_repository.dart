import '../../domain/entities/cloth_item_entity.dart';
import '../../domain/entities/wardrobe_entity.dart';
import '../../domain/repositories/wardrobe_repository.dart';

import '../datasources/wardrobe_local_datasource.dart';

class SQLiteWardrobeRepository implements WardrobeRepository {
  final WardrobeLocalDatasource localDatasource;

  const SQLiteWardrobeRepository({required this.localDatasource});

  @override
  Future<List<WardrobeEntity>> getWardrobeCategories() {
    return localDatasource.getWardrobeCategories();
  }

  @override
  Future<List<ClothItemEntity>> getClothingItemsByCategory({
    required String userId,
    required String wardrobeId,
  }) {
    return localDatasource.getClothingItemsByCategory(
      userId: userId,
      wardrobeId: wardrobeId,
    );
  }

  @override
  Future<List<ClothItemEntity>> getAllClothingItems({required String userId}) {
    return localDatasource.getAllClothingItems(userId: userId);
  }

  @override
  Future<ClothItemEntity> addClothingItem({
    required ClothItemEntity clothItem,
  }) {
    return localDatasource.addClothingItem(clothItem: clothItem);
  }

  @override
  Future<void> deleteClothingItem({
    required String userId,
    required String clothItemId,
  }) {
    return localDatasource.deleteClothingItem(
      userId: userId,
      clothItemId: clothItemId,
    );
  }
}
