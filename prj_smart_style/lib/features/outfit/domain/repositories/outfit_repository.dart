import '../entities/outfit_input_entity.dart';
import '../entities/outfit_output_entity.dart';

abstract class OutfitRepository {
  Future<List<OutfitOutputEntity>> generateOutfitRecommendations({
    required OutfitInputEntity input,
  });

  Future<List<OutfitOutputEntity>> regenerateOutfitRecommendations({
    required OutfitInputEntity input,
  });
}
