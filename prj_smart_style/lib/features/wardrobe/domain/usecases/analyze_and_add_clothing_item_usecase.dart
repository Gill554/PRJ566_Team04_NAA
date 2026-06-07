import '../entities/cloth_item_entity.dart';
import '../repositories/clothing_analysis_repository.dart';
import '../repositories/wardrobe_repository.dart';

class AnalyzeAndAddClothingItemUseCase {
  final ClothingAnalysisRepository analysisRepository;
  final WardrobeRepository wardrobeRepository;

  const AnalyzeAndAddClothingItemUseCase({
    required this.analysisRepository,
    required this.wardrobeRepository,
  });

  Future<ClothItemEntity> call({
    required String userId,
    required String imagePath,
  }) async {
    final analysisResult = await analysisRepository.analyzeClothingImage(
      imagePath: imagePath,
    );

    if (!analysisResult.isValid) {
      throw Exception(analysisResult.errorMessage ?? "Invalid clothing image");
    }

    if (analysisResult.wardrobeId == null ||
        analysisResult.styleIds == null ||
        analysisResult.colorIds == null ||
        analysisResult.description == null) {
      throw Exception("Incomplete clothing analysis result");
    }

    if (analysisResult.styleIds!.isEmpty ||
        analysisResult.colorIds!.isEmpty ||
        analysisResult.description!.trim().isEmpty) {
      throw Exception("Incomplete clothing analysis result");
    }

    final clothItem = ClothItemEntity(
      id: 'cloth_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      wardrobeId: analysisResult.wardrobeId!,
      photoPath: imagePath,
      isImageAvailable: true,
      createdAt: DateTime.now(),
      aiDescription: analysisResult.description!.trim(),
      aiStyleIds: analysisResult.styleIds!,
      aiColorIds: analysisResult.colorIds!,
    );

    return wardrobeRepository.addClothingItem(clothItem: clothItem);
  }
}
