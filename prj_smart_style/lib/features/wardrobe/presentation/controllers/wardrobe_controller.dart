import 'package:flutter/material.dart';
import '../../domain/entities/cloth_item_entity.dart';
import '../../domain/entities/wardrobe_entity.dart';
import '../../domain/usecases/add_clothing_item_usecase.dart';
import '../../domain/usecases/delete_clothing_item_usecase.dart';
import '../../domain/usecases/get_all_clothing_items_usecase.dart';
import '../../domain/usecases/get_clothing_items_by_category_usecase.dart';
import '../../domain/usecases/get_wardrobe_categories_usecase.dart';
import '../../domain/usecases/analyze_and_add_clothing_item_usecase.dart';

class WardrobeController extends ChangeNotifier {
  final GetWardrobeCategoriesUseCase getWardrobeCategoriesUseCase;
  final GetClothingItemsByCategoryUseCase getClothingItemsByCategoryUseCase;
  final GetAllClothingItemsUseCase getAllClothingItemsUseCase;
  final AddClothingItemUseCase addClothingItemUseCase;
  final DeleteClothingItemUseCase deleteClothingItemUseCase;
  final AnalyzeAndAddClothingItemUseCase analyzeAndAddClothingItemUseCase;

  WardrobeController({
    required this.getWardrobeCategoriesUseCase,
    required this.getClothingItemsByCategoryUseCase,
    required this.getAllClothingItemsUseCase,
    required this.addClothingItemUseCase,
    required this.deleteClothingItemUseCase,
    required this.analyzeAndAddClothingItemUseCase,
  });

  bool isLoading = false;
  String? errorMessage;
  List<WardrobeEntity> categories = [];
  List<ClothItemEntity> allClothingItems = [];
  Map<String, List<ClothItemEntity>> itemsByCategory = {};

  Future<void> loadWardrobe({required String userId}) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      categories = await getWardrobeCategoriesUseCase();
      allClothingItems = await getAllClothingItemsUseCase(userId: userId);

      final Map<String, List<ClothItemEntity>> loadedItems = {};

      for (final category in categories) {
        loadedItems[category.id] = await getClothingItemsByCategoryUseCase(
          userId: userId,
          wardrobeId: category.id,
        );
      }

      itemsByCategory = loadedItems;
    } catch (e) {
      errorMessage = "Failed to load wardrobe";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> addClothingItem({required ClothItemEntity clothItem}) async {
    try {
      errorMessage = null;

      notifyListeners();

      final newItem = await addClothingItemUseCase(clothItem: clothItem);
      allClothingItems = [...allClothingItems, newItem];
      final currentItems = itemsByCategory[newItem.wardrobeId] ?? [];
      itemsByCategory[newItem.wardrobeId] = [...currentItems, newItem];

      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to add clothing item";

      notifyListeners();
    }
  }

  Future<void> deleteClothingItem({
    required String userId,
    required String clothItemId,
    required String wardrobeId,
  }) async {
    try {
      errorMessage = null;

      notifyListeners();

      await deleteClothingItemUseCase(userId: userId, clothItemId: clothItemId);

      allClothingItems.removeWhere((item) {
        return item.id == clothItemId && item.userId == userId;
      });

      itemsByCategory[wardrobeId]?.removeWhere((item) {
        return item.id == clothItemId && item.userId == userId;
      });

      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to delete clothing item";

      notifyListeners();
    }
  }

  List<ClothItemEntity> getItemsByCategory(String wardrobeId) {
    return itemsByCategory[wardrobeId] ?? [];
  }

  Future<bool> analyzeAndAddClothingItem({
    required String userId,
    required String imagePath,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final newItem = await analyzeAndAddClothingItemUseCase(
        userId: userId,
        imagePath: imagePath,
      );

      allClothingItems = [...allClothingItems, newItem];

      final currentItems = itemsByCategory[newItem.wardrobeId] ?? [];

      itemsByCategory[newItem.wardrobeId] = [...currentItems, newItem];

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<ClothItemEntity> get allItems {
    return allClothingItems;
  }
}
