import '../entities/cloth_item_entity.dart';
import '../repositories/wardrobe_repository.dart';

class GetClothingItemsByCategoryUseCase {
  final WardrobeRepository repository;

  const GetClothingItemsByCategoryUseCase(this.repository);

  Future<List<ClothItemEntity>> call({
    required String userId,
    required String wardrobeId,
  }) {
    return repository.getClothingItemsByCategory(
      userId: userId,
      wardrobeId: wardrobeId,
    );
  }
}
