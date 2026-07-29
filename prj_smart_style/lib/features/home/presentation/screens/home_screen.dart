import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/favorites/domain/entities/favorite_outfit_entity.dart';
import 'package:prj_smart_style/features/favorites/presentation/controllers/favorites_controller.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';
import 'package:prj_smart_style/features/preferences/presentation/controllers/preferences_controller.dart';
import 'package:prj_smart_style/features/wardrobe/domain/constants/wardrobe_categories.dart';
import 'package:prj_smart_style/features/wardrobe/presentation/controllers/wardrobe_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().currentUser?.id;

      if (userId == null) return;

      context.read<FavoritesController>().loadFavorites(userId);
      context.read<PreferencesController>().loadProfiles(userId);
      context.read<WardrobeController>().loadWardrobe(userId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _UserProfile(),
              const SizedBox(height: AppSpacing.xl),
              const _NewOutfit(),
              const SizedBox(height: AppSpacing.xl),
              const _FavoriteOutfitsSection(),
              const SizedBox(height: AppSpacing.xl),
              const _ProfileShortcutSection(),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'profile');
      },
      child: Row(
        children: [
          const CircleAvatar(radius: AppRadius.lg, child: Icon(Icons.person)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            "Hello, ${authController.currentUser?.fullName ?? "Unknown User"}!",
            style: AppTextStyles.title,
          ),
        ],
      ),
    );
  }
}

class _NewOutfit extends StatelessWidget {
  const _NewOutfit();

  @override
  Widget build(BuildContext context) {
    final preferencesController = context.watch<PreferencesController>();
    final wardrobeController = context.watch<WardrobeController>();

    final profileCount = preferencesController.profiles.length;

    final topsCount = wardrobeController
        .getItemsByCategory(WardrobeCategories.tops.id)
        .where((item) => item.isImageAvailable)
        .length;

    final bottomsCount = wardrobeController
        .getItemsByCategory(WardrobeCategories.bottoms.id)
        .where((item) => item.isImageAvailable)
        .length;

    final footwearCount = wardrobeController
        .getItemsByCategory(WardrobeCategories.footwear.id)
        .where((item) => item.isImageAvailable)
        .length;

    final totalItems = wardrobeController.allItems
        .where((item) => item.isImageAvailable)
        .length;

    final isReady =
        profileCount > 0 &&
        topsCount > 0 &&
        bottomsCount > 0 &&
        footwearCount > 0;

    final isLoading =
        preferencesController.isLoading || wardrobeController.isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.black54),
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF7FF), Color(0xFFD8EFFC)],
        ),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.checkroom_outlined : Icons.info_outline,
            size: AppIcons.xl,
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReady ? "Your wardrobe is ready" : "Complete your setup",
                  style: AppTextStyles.subtitle,
                ),

                const SizedBox(height: AppSpacing.xs),

                if (isLoading)
                  const Text(
                    "Checking your wardrobe and preferences...",
                    style: AppTextStyles.small,
                  )
                else
                  Text(
                    "$totalItems clothing items available\n"
                    "$profileCount style profile${profileCount == 1 ? '' : 's'} configured",
                    style: AppTextStyles.small,
                  ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  isReady
                      ? "AI-powered recommendations based on your wardrobe and preferences."
                      : _getMissingSetupMessage(
                          profileCount: profileCount,
                          topsCount: topsCount,
                          bottomsCount: bottomsCount,
                          footwearCount: footwearCount,
                        ),
                  style: AppTextStyles.small,
                ),

                const SizedBox(height: AppSpacing.md),

                SizedBox(
                  height: AppSpacing.xl,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isReady && !isLoading
                        ? () {
                            Navigator.pushNamed(context, 'outfit_request');
                          }
                        : null,
                    child: Text(isReady ? "Generate Outfit" : "Setup Required"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMissingSetupMessage({
    required int profileCount,
    required int topsCount,
    required int bottomsCount,
    required int footwearCount,
  }) {
    if (profileCount == 0) {
      return "Create at least one style preference profile.";
    }

    if (topsCount == 0) {
      return "Add at least one tops item.";
    }

    if (bottomsCount == 0) {
      return "Add at least one bottoms item.";
    }

    if (footwearCount == 0) {
      return "Add at least one footwear item.";
    }

    return "Complete your wardrobe setup to generate outfits.";
  }
}

class _FavoriteOutfitsSection extends StatelessWidget {
  const _FavoriteOutfitsSection();

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.watch<FavoritesController>();

    final sortedFavorites = [...favoritesController.favorites]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final previewFavorites = sortedFavorites.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Saved Looks", style: AppTextStyles.subtitle),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'favorites');
              },
              child: const Text("See All >", style: AppTextStyles.small),
            ),
          ],
        ),

        const Text("Favorite outfits you`ve saved", style: AppTextStyles.small),

        const SizedBox(height: AppSpacing.md),

        if (favoritesController.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (favoritesController.errorMessage != null)
          Text(
            favoritesController.errorMessage!,
            style: AppTextStyles.small.copyWith(color: AppColors.error),
          )
        else if (previewFavorites.isEmpty)
          const Text("No saved outfits yet.", style: AppTextStyles.small)
        else
          Row(
            children: List.generate(2, (index) {
              if (index >= previewFavorites.length) {
                return const Expanded(child: SizedBox());
              }

              final favorite = previewFavorites[index];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? AppSpacing.lg : 0,
                  ),
                  child: _OutfitPreviewCard(favorite: favorite),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _OutfitPreviewCard extends StatelessWidget {
  final FavoriteOutfitEntity favorite;

  const _OutfitPreviewCard({required this.favorite});

  @override
  Widget build(BuildContext context) {
    final outfitImage = favorite.outfit.outfitImage;

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClothingImageBox(
              imagePath: outfitImage?.photoAddress ?? "",
              isImageAvailable: outfitImage?.isImageAvailable ?? false,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'favorite_detail',
                  arguments: favorite,
                );
              },
            ),
          ),
          const Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: Icon(
              Icons.favorite,
              size: AppIcons.lg,
              color: AppColors.favoriteHeart,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileShortcutSection extends StatelessWidget {
  const _ProfileShortcutSection();

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      _ShortcutButton(
        icon: Icons.checkroom_outlined,
        label: "My clothes",
        onTap: () => Navigator.pushNamed(context, 'wardrobe'),
      ),
      _ShortcutButton(
        icon: Icons.add_photo_alternate_outlined,
        label: "Upload clothes",
        onTap: () => Navigator.pushNamed(context, 'upload_clothing'),
      ),
      _ShortcutButton(
        icon: Icons.thumb_up_alt_outlined,
        label: "My Style Preferences",
        onTap: () => Navigator.pushNamed(context, 'preferences'),
      ),
      _ShortcutButton(
        icon: Icons.settings_outlined,
        label: "Settings",
        onTap: () => Navigator.pushNamed(context, 'profile'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Profile Shortcuts", style: AppTextStyles.subtitle),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          itemCount: shortcuts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) => shortcuts[index],
        ),
      ],
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShortcutButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: Colors.black54),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final iconSize = constraints.maxHeight * 0.5;

                  return Icon(icon, size: iconSize);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoftGray,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              label,
              style: AppTextStyles.small,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
