import '../entities/favorite_outfit_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  const GetFavoritesUseCase(this.repository);

  Future<List<FavoriteOutfitEntity>> call({required String userId}) {
    return repository.getFavorites(userId: userId);
  }
}
