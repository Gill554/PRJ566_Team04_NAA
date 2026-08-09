import 'package:flutter/material.dart';

import '../../domain/entities/outfit_input_entity.dart';
import '../../domain/entities/outfit_output_entity.dart';
import '../../domain/usecases/generate_outfits_with_collage_usecase.dart';

class OutfitController extends ChangeNotifier {
  final GenerateOutfitsWithCollageUseCase generateOutfitsWithCollageUseCase;

  OutfitController({required this.generateOutfitsWithCollageUseCase});

  bool isLoading = false;
  String? errorMessage;

  OutfitInputEntity? currentInput;
  List<OutfitOutputEntity> recommendations = [];

  Future<void> generateRecommendations({
    required OutfitInputEntity input,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      currentInput = input;
      notifyListeners();

      recommendations = await generateOutfitsWithCollageUseCase(input: input);
    } catch (e) {
      errorMessage = "Failed to generate outfit recommendations";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> regenerateRecommendations() async {
    if (currentInput == null) {
      errorMessage = "No outfit input found";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final inputWithPreviousOutputs = OutfitInputEntity(
        id: currentInput!.id,
        details: currentInput!.details,
        availableClothingItems: currentInput!.availableClothingItems,
        previousOutfitOutputs: recommendations,
      );

      currentInput = inputWithPreviousOutputs;

      recommendations = await generateOutfitsWithCollageUseCase.regenerate(
        input: inputWithPreviousOutputs,
      );
    } catch (e) {
      errorMessage = "Failed to regenerate outfit recommendations";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearRecommendations() {
    currentInput = null;
    recommendations = [];
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
