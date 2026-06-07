import '../entities/cloth_item_entity.dart';
import '../repositories/wardrobe_repository.dart';

class AddClothingItemUseCase {
  final WardrobeRepository repository;

  const AddClothingItemUseCase(this.repository);

  Future<ClothItemEntity> call({required ClothItemEntity clothItem}) {
    return repository.addClothingItem(clothItem: clothItem);
  }
}
