import '../entities/favorite_outfit_entity.dart';
import '../repositories/favorites_repository.dart';

class SaveFavoriteUseCase {
  final FavoritesRepository repository;

  const SaveFavoriteUseCase(this.repository);

  Future<FavoriteOutfitEntity> call({required FavoriteOutfitEntity favorite}) {
    return repository.saveFavorite(favorite: favorite);
  }
}
