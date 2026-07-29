import '../repositories/favorites_repository.dart';

class DeleteFavoriteUseCase {
  final FavoritesRepository repository;

  const DeleteFavoriteUseCase(this.repository);

  Future<void> call({required String favoriteId}) {
    return repository.deleteFavorite(favoriteId: favoriteId);
  }
}
