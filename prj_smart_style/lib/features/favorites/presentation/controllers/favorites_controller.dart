import 'package:flutter/material.dart';
import '../../domain/entities/favorite_outfit_entity.dart';
import '../../domain/usecases/delete_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/save_favorite_usecase.dart';

class FavoritesController extends ChangeNotifier {
  final GetFavoritesUseCase getFavoritesUseCase;
  final SaveFavoriteUseCase saveFavoriteUseCase;
  final DeleteFavoriteUseCase deleteFavoriteUseCase;

  FavoritesController({
    required this.getFavoritesUseCase,
    required this.saveFavoriteUseCase,
    required this.deleteFavoriteUseCase,
  });

  bool isLoading = false;
  String? errorMessage;

  List<FavoriteOutfitEntity> favorites = [];

  Future<void> loadFavorites(String userId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      favorites = await getFavoritesUseCase(userId: userId);
    } catch (e) {
      errorMessage = "Failed to load favorites";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveFavorite(FavoriteOutfitEntity favorite) async {
    final savedFavorite = await saveFavoriteUseCase(favorite: favorite);

    favorites.add(savedFavorite);
    notifyListeners();
  }

  Future<void> deleteFavorite(String favoriteId) async {
    await deleteFavoriteUseCase(favoriteId: favoriteId);

    favorites.removeWhere((favorite) => favorite.id == favoriteId);
    notifyListeners();
  }
}
