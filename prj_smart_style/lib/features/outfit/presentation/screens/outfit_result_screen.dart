import 'package:flutter/material.dart';
import 'package:prj_smart_style/shared/widgets/secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/favorites/domain/entities/favorite_outfit_entity.dart';
import 'package:prj_smart_style/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:prj_smart_style/features/outfit/domain/entities/outfit_output_entity.dart';
import 'package:prj_smart_style/features/outfit/presentation/controllers/outfit_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:prj_smart_style/shared/widgets/app_info_dialog.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';
import 'package:prj_smart_style/shared/widgets/fullscreen_image_preview.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';

class OutfitResultScreen extends StatefulWidget {
  const OutfitResultScreen({super.key});

  @override
  State<OutfitResultScreen> createState() => _OutfitResultScreenState();
}

class _OutfitResultScreenState extends State<OutfitResultScreen> {
  final Set<String> savedOutfitIds = {};

  void _confirmRegenerate() {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Generate New Recommendations",
          description:
              "The current outfit recommendations will be replaced. Do you want to continue?",
          confirmText: "Generate",
          cancelText: "Cancel",
          onConfirm: () async {
            savedOutfitIds.clear();

            await context.read<OutfitController>().regenerateRecommendations();
          },
        );
      },
    );
  }

  void _showSavedMessage() {
    showDialog(
      context: context,
      builder: (_) {
        return const AppInfoDialog(
          title: "Outfit Saved",
          description: "This outfit has been saved to your favorites.",
          buttonText: "OK",
        );
      },
    );
  }

  Future<void> _confirmSaveFavorite({
    required OutfitOutputEntity outfit,
  }) async {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Save Outfit",
          description: "Do you want to save this outfit to your favorites?",
          confirmText: "Save",
          cancelText: "Cancel",
          onConfirm: () async {
            final userId = context.read<AuthController>().currentUser?.id;
            if (userId == null) return;

            final outfitController = context.read<OutfitController>();
            final currentInput = outfitController.currentInput;

            if (currentInput == null) {
              return;
            }

            final favorite = FavoriteOutfitEntity(
              id: 'favorite_${DateTime.now().millisecondsSinceEpoch}',
              userId: userId,
              createdAt: DateTime.now(),
              details: currentInput.details,
              outfit: outfit,
            );

            await context.read<FavoritesController>().saveFavorite(favorite);

            if (!mounted) return;

            setState(() {
              savedOutfitIds.add(outfit.id);
            });

            _showSavedMessage();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final outfitController = context.watch<OutfitController>();
    final recommendations = outfitController.recommendations;

    return Scaffold(
      appBar: const AppBackAppBar(title: "Outfit Recommendation"),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: outfitController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : recommendations.isEmpty
            ? Center(
                child: Text(
                  outfitController.errorMessage ??
                      "No outfit recommendations available.",
                  style: AppTextStyles.body.copyWith(
                    color: outfitController.errorMessage != null
                        ? AppColors.error
                        : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...recommendations.map((recommendation) {
                      final isSaved = savedOutfitIds.contains(
                        recommendation.id,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        child: _OutfitRecommendationCard(
                          recommendation: recommendation,
                          isSaved: isSaved,
                          onSave: () {
                            _confirmSaveFavorite(outfit: recommendation);
                          },
                        ),
                      );
                    }),

                    PrimaryButton(
                      text: "Generate New Recommendation",
                      onPressed: outfitController.isLoading
                          ? null
                          : _confirmRegenerate,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    SecondaryButton(
                      text: "Go Home",
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'home',
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _OutfitRecommendationCard extends StatelessWidget {
  final OutfitOutputEntity recommendation;
  final bool isSaved;
  final VoidCallback onSave;

  const _OutfitRecommendationCard({
    required this.recommendation,
    required this.isSaved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final outfitImage = recommendation.outfitImage;
    final favoritesController = context.watch<FavoritesController>();

    final imagePath = outfitImage?.photoAddress ?? "";
    final isImageAvailable = outfitImage?.isImageAvailable ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FullscreenImagePreview(
            fullscreenChild: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: ClothingImageBox(
                  imagePath: imagePath,
                  isImageAvailable: isImageAvailable,
                ),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: ClothingImageBox(
                imagePath: imagePath,
                isImageAvailable: isImageAvailable,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(recommendation.title, style: AppTextStyles.subtitle),

          const SizedBox(height: AppSpacing.sm),

          Text(recommendation.description, style: AppTextStyles.body),

          const SizedBox(height: AppSpacing.md),

          PrimaryButton(
            text: isSaved
                ? "Saved"
                : favoritesController.isLoading
                ? "Saving..."
                : "Save Outfit",
            onPressed: isSaved || favoritesController.isLoading ? null : onSave,
          ),

          if (favoritesController.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              favoritesController.errorMessage!,
              style: AppTextStyles.small.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
