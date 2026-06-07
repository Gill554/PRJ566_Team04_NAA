import '../repositories/wardrobe_repository.dart';

class DeleteClothingItemUseCase {
  final WardrobeRepository repository;

  const DeleteClothingItemUseCase(this.repository);

  Future<void> call({required String userId, required String clothItemId}) {
    return repository.deleteClothingItem(
      userId: userId,
      clothItemId: clothItemId,
    );
  }
}
