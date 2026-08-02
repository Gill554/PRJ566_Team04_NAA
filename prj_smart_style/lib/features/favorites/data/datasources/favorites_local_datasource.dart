import 'package:prj_smart_style/shared/local_database/database_service.dart';
import 'package:prj_smart_style/shared/local_database/database_tables.dart';

import '../models/favorite_outfit_model.dart';
import '../../domain/entities/favorite_outfit_entity.dart';

class FavoritesLocalDatasource {
  final DatabaseService databaseService;

  const FavoritesLocalDatasource({required this.databaseService});

  Future<List<FavoriteOutfitEntity>> getFavorites({
    required String userId,
  }) async {
    final rows = await databaseService.query(
      table: DatabaseTables.favoriteOutfits,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );

    return rows.map((row) {
      return FavoriteOutfitModel.fromMap(row).toEntity();
    }).toList();
  }

  Future<FavoriteOutfitEntity> saveFavorite({
    required FavoriteOutfitEntity favorite,
  }) async {
    final model = FavoriteOutfitModel.fromEntity(favorite);

    await databaseService.insert(
      table: DatabaseTables.favoriteOutfits,
      values: model.toMap(),
    );

    return model.toEntity();
  }

  Future<void> deleteFavorite({required String favoriteId}) async {
    await databaseService.delete(
      table: DatabaseTables.favoriteOutfits,
      where: 'id = ?',
      whereArgs: [favoriteId],
    );
  }
}
