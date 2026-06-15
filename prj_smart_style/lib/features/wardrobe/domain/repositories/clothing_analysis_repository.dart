import '../entities/clothing_analysis_result_entity.dart';

abstract class ClothingAnalysisRepository {
  Future<ClothingAnalysisResultEntity> analyzeClothingImage({
    required String imagePath,
  });
}
