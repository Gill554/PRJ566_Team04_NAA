import '../../../../shared/image_processing/domain/usecases/create_outfit_collage_usecase.dart';
import '../entities/outfit_image_entity.dart';
import '../entities/outfit_input_entity.dart';
import '../entities/outfit_output_entity.dart';
import '../repositories/outfit_repository.dart';

class GenerateOutfitsWithCollageUseCase {
  final OutfitRepository outfitRepository;
  final CreateOutfitCollageUseCase createOutfitCollageUseCase;

  const GenerateOutfitsWithCollageUseCase({
    required this.outfitRepository,
    required this.createOutfitCollageUseCase,
  });

  Future<List<OutfitOutputEntity>> call({
    required OutfitInputEntity input,
  }) async {
    final outfits = await outfitRepository.generateOutfitRecommendations(
      input: input,
    );

    return _addCollages(outfits);
  }

  Future<List<OutfitOutputEntity>> regenerate({
    required OutfitInputEntity input,
  }) async {
    final outfits = await outfitRepository.regenerateOutfitRecommendations(
      input: input,
    );

    return _addCollages(outfits);
  }

  Future<List<OutfitOutputEntity>> _addCollages(
    List<OutfitOutputEntity> outfits,
  ) async {
    final updatedOutfits = <OutfitOutputEntity>[];

    for (final outfit in outfits) {
      final collagePath = await createOutfitCollageUseCase(
        clothingItems: outfit.selectedClothingItems,
      );

      final outfitImage = OutfitImageEntity(
        id: 'image_${outfit.id}',
        photoAddress: collagePath,
        isImageAvailable: true,
      );

      updatedOutfits.add(outfit.copyWith(outfitImage: outfitImage));
    }

    return updatedOutfits;
  }
}
