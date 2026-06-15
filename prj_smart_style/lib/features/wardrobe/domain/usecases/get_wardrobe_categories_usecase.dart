import '../entities/wardrobe_entity.dart';
import '../repositories/wardrobe_repository.dart';

class GetWardrobeCategoriesUseCase {
  final WardrobeRepository repository;

  const GetWardrobeCategoriesUseCase(this.repository);

  Future<List<WardrobeEntity>> call() {
    return repository.getWardrobeCategories();
  }
}
