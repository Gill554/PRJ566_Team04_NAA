import '../entities/cloth_item_entity.dart';
import '../repositories/wardrobe_repository.dart';

class GetAllClothingItemsUseCase {
  final WardrobeRepository repository;

  const GetAllClothingItemsUseCase(this.repository);

  Future<List<ClothItemEntity>> call({required String userId}) {
    return repository.getAllClothingItems(userId: userId);
  }
}
