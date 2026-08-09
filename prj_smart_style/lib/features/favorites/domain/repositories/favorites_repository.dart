import '../entities/favorite_outfit_entity.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteOutfitEntity>> getFavorites({required String userId});

  Future<FavoriteOutfitEntity> saveFavorite({
    required FavoriteOutfitEntity favorite,
  });

  Future<void> deleteFavorite({required String favoriteId});
}
