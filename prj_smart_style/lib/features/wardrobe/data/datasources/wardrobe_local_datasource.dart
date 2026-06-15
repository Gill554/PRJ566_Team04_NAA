import 'dart:io';

import 'package:prj_smart_style/shared/local_database/database_service.dart';
import 'package:prj_smart_style/shared/local_database/database_tables.dart';

import '../models/cloth_item_model.dart';
import '../../domain/constants/wardrobe_categories.dart';
import '../../domain/entities/cloth_item_entity.dart';
import '../../domain/entities/wardrobe_entity.dart';

class WardrobeLocalDatasource {
  final DatabaseService databaseService;

  const WardrobeLocalDatasource({required this.databaseService});

  Future<List<WardrobeEntity>> getWardrobeCategories() async {
    return WardrobeCategories.all;
  }

  Future<List<ClothItemEntity>> getClothingItemsByCategory({
    required String userId,
    required String wardrobeId,
  }) async {
    final rows = await databaseService.query(
      table: DatabaseTables.clothingItems,
      where: 'userId = ? AND wardrobeId = ?',
      whereArgs: [userId, wardrobeId],
      orderBy: 'createdAt DESC',
    );

    return _rowsToEntities(rows);
  }

  Future<List<ClothItemEntity>> getAllClothingItems({
    required String userId,
  }) async {
    final rows = await databaseService.query(
      table: DatabaseTables.clothingItems,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return _rowsToEntities(rows);
  }

  Future<ClothItemEntity> addClothingItem({
    required ClothItemEntity clothItem,
  }) async {
    final model = ClothItemModel.fromEntity(clothItem);

    await databaseService.insert(
      table: DatabaseTables.clothingItems,
      values: model.toMap(),
    );

    final exists = await File(model.photoPath).exists();

    return model.toEntity(isImageAvailable: exists);
  }

  Future<void> deleteClothingItem({
    required String userId,
    required String clothItemId,
  }) async {
    await databaseService.delete(
      table: DatabaseTables.clothingItems,
      where: 'userId = ? AND id = ?',
      whereArgs: [userId, clothItemId],
    );
  }

  Future<List<ClothItemEntity>> _rowsToEntities(
    List<Map<String, dynamic>> rows,
  ) async {
    final entities = <ClothItemEntity>[];

    for (final row in rows) {
      final model = ClothItemModel.fromMap(row);
      final exists = await File(model.photoPath).exists();

      entities.add(model.toEntity(isImageAvailable: exists));
    }

    return entities;
  }
}
