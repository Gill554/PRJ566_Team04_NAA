import 'package:prj_smart_style/features/preferences/domain/constants/preference_colors.dart';
import 'package:prj_smart_style/features/preferences/domain/constants/preference_styles.dart';
import 'package:prj_smart_style/features/wardrobe/domain/constants/wardrobe_categories.dart';
import 'package:prj_smart_style/features/wardrobe/domain/entities/clothing_analysis_result_entity.dart';
import 'package:prj_smart_style/features/wardrobe/domain/repositories/clothing_analysis_repository.dart';

class MockClothingAnalysisRepository implements ClothingAnalysisRepository {
  @override
  Future<ClothingAnalysisResultEntity> analyzeClothingImage({
    required String imagePath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (imagePath.trim().isEmpty) {
      return const ClothingAnalysisResultEntity(
        isValid: false,
        errorMessage: "No image was selected.",
      );
    }

    return ClothingAnalysisResultEntity(
      isValid: true,
      wardrobeId: WardrobeCategories.tops.id,
      styleIds: [PreferenceStyles.casual.id, PreferenceStyles.minimalist.id],
      colorIds: [PreferenceColors.neutral.id, PreferenceColors.lightTones.id],
      description:
          "A simple casual clothing item saved for Sprint 02 without AI analysis.",
    );
  }
}
