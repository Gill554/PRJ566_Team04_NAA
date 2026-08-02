import '../../domain/entities/favorite_outfit_entity.dart';
import '../../domain/repositories/favorites_repository.dart';

import '../datasources/favorites_local_datasource.dart';

class SQLiteFavoritesRepository implements FavoritesRepository {
  final FavoritesLocalDatasource localDatasource;

  const SQLiteFavoritesRepository({required this.localDatasource});

  @override
  Future<List<FavoriteOutfitEntity>> getFavorites({required String userId}) {
    return localDatasource.getFavorites(userId: userId);
  }

  @override
  Future<FavoriteOutfitEntity> saveFavorite({
    required FavoriteOutfitEntity favorite,
  }) {
    return localDatasource.saveFavorite(favorite: favorite);
  }

  @override
  Future<void> deleteFavorite({required String favoriteId}) {
    return localDatasource.deleteFavorite(favoriteId: favoriteId);
  }
}
