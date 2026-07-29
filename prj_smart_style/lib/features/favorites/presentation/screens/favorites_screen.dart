import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/favorites/domain/entities/favorite_outfit_entity.dart';
import 'package:prj_smart_style/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:prj_smart_style/features/preferences/domain/constants/preference_styles.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static const String allFilterId = "all";

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedFilterId = FavoritesScreen.allFilterId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().currentUser?.id;

      if (userId == null) return;

      context.read<FavoritesController>().loadFavorites(userId);
    });
  }

  List<FavoriteOutfitEntity> _getFilteredFavorites(
    List<FavoriteOutfitEntity> favorites,
  ) {
    if (selectedFilterId == FavoritesScreen.allFilterId) {
      return favorites;
    }

    return favorites.where((favorite) {
      return favorite.outfit.selectedClothingItems.any((item) {
        return item.aiStyleIds.contains(selectedFilterId);
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.watch<FavoritesController>();
    final sortedFavorites = [...favoritesController.favorites]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final filteredFavorites = _getFilteredFavorites(sortedFavorites);

    return Scaffold(
      appBar: const AppBackAppBar(title: "My Favorites"),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _FavoritesFilters(
              selectedFilterId: selectedFilterId,
              onFilterSelected: (filterId) {
                setState(() {
                  selectedFilterId = filterId;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            if (favoritesController.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (favoritesController.errorMessage != null)
              Expanded(
                child: Center(
                  child: Text(
                    favoritesController.errorMessage!,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (filteredFavorites.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No favorite outfits found.",
                    style: AppTextStyles.body,
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  itemCount: filteredFavorites.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.xl,
                    mainAxisSpacing: AppSpacing.xl,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final favorite = filteredFavorites[index];
                    final outfitImage = favorite.outfit.outfitImage;

                    return ClothingImageBox(
                      imagePath: outfitImage?.photoAddress ?? "",
                      isImageAvailable: outfitImage?.isImageAvailable ?? false,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'favorite_detail',
                          arguments: favorite,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesFilters extends StatelessWidget {
  final String selectedFilterId;
  final ValueChanged<String> onFilterSelected;

  const _FavoritesFilters({
    required this.selectedFilterId,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      const _FavoriteFilterItem(id: FavoritesScreen.allFilterId, title: "All"),
      ...PreferenceStyles.all.map((style) {
        return _FavoriteFilterItem(id: style.id, title: style.title);
      }),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter.id == selectedFilterId;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () {
                onFilterSelected(filter.id);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.selectedFilter
                      : AppColors.surfaceSoftGray,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Text(filter.title, style: AppTextStyles.small),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FavoriteFilterItem {
  final String id;
  final String title;

  const _FavoriteFilterItem({required this.id, required this.title});
}
