import 'package:flutter/material.dart';
import 'package:prj_smart_style/shared/widgets/fullscreen_image_preview.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/favorites/domain/entities/favorite_outfit_entity.dart';
import 'package:prj_smart_style/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';

class FavoriteDetailScreen extends StatelessWidget {
  const FavoriteDetailScreen({super.key});

  void _confirmDelete({
    required BuildContext context,
    required FavoriteOutfitEntity favorite,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Remove Favorite",
          description:
              "Are you sure you want to remove this outfit from favorites?",
          confirmText: "Remove",
          cancelText: "Cancel",
          isDanger: true,
          onConfirm: () async {
            await context.read<FavoritesController>().deleteFavorite(
              favorite.id,
            );

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! FavoriteOutfitEntity) {
      return Scaffold(
        appBar: const AppBackAppBar(title: "Favorite Detail"),
        body: const Center(
          child: Text(
            "No favorite outfit selected.",
            style: AppTextStyles.body,
          ),
        ),
      );
    }

    final favorite = args;

    final outfit = favorite.outfit;
    final outfitImage = outfit.outfitImage;
    final details = favorite.details;
    final favoritesController = context.watch<FavoritesController>();

    return Scaffold(
      appBar: const AppBackAppBar(title: "My Favorite"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FullscreenImagePreview(
              fullscreenChild: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClothingImageBox(
                    imagePath: outfitImage?.photoAddress ?? "",
                    isImageAvailable: outfitImage?.isImageAvailable ?? false,
                  ),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: ClothingImageBox(
                  imagePath: outfitImage?.photoAddress ?? "",
                  isImageAvailable: outfitImage?.isImageAvailable ?? false,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(outfit.title, style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.sm),

            Text(outfit.description, style: AppTextStyles.body),

            const SizedBox(height: AppSpacing.xl),

            _DetailsCard(
              occasion: details.occasion,
              style: details.userProfilePreferences.preferencesStyle.title,
              colorPalette:
                  details.userProfilePreferences.preferencesColor.title,
              weather: details.weather,
            ),

            const SizedBox(height: AppSpacing.xl),

            Center(
              child: Text(
                "Saved on: ${_formatDate(favorite.createdAt)}",
                style: AppTextStyles.body,
              ),
            ),

            if (favoritesController.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                favoritesController.errorMessage!,
                style: AppTextStyles.small.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: AppSpacing.xxl),

            PrimaryButton(
              text: favoritesController.isLoading
                  ? "Removing..."
                  : "Remove From Favorites",
              onPressed: favoritesController.isLoading
                  ? null
                  : () {
                      _confirmDelete(context: context, favorite: favorite);
                    },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return "${date.day} ${months[date.month - 1]}, ${date.year}";
  }
}

class _DetailsCard extends StatelessWidget {
  final String occasion;
  final String style;
  final String colorPalette;
  final String weather;

  const _DetailsCard({
    required this.occasion,
    required this.style,
    required this.colorPalette,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.detailsBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          const _DetailsHeader(),
          _DetailRow(label: "Occasion:", value: occasion),
          _DetailRow(label: "Style:", value: style),
          _DetailRow(label: "Color Palette:", value: colorPalette),
          _DetailRow(label: "Weather:", value: weather),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _DetailsHeader extends StatelessWidget {
  const _DetailsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.detailsHeader,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: const Center(
        child: Text("Details", style: AppTextStyles.subtitle),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(child: Text(label, style: AppTextStyles.body)),
                Expanded(child: Text(value, style: AppTextStyles.body)),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
