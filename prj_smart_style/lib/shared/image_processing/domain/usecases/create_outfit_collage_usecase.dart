import '../../../../features/wardrobe/domain/entities/cloth_item_entity.dart';
import '../repositories/image_collage_repository.dart';

class CreateOutfitCollageUseCase {
  final ImageCollageRepository repository;

  const CreateOutfitCollageUseCase(this.repository);

  Future<String> call({required List<ClothItemEntity> clothingItems}) {
    return repository.createCollage(clothingItems: clothingItems);
  }
}
