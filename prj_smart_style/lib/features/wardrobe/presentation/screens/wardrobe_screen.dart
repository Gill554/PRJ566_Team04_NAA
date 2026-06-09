import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/wardrobe/domain/entities/cloth_item_entity.dart';
import 'package:prj_smart_style/features/wardrobe/domain/entities/wardrobe_entity.dart';
import 'package:prj_smart_style/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().currentUser?.id;
      if (userId == null) return;

      context.read<WardrobeController>().loadWardrobe(userId: userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wardrobeController = context.watch<WardrobeController>();

    return Scaffold(
      appBar: const AppBackAppBar(title: "My Wardrobe"),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: wardrobeController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : wardrobeController.errorMessage != null
            ? Center(
                child: Text(
                  wardrobeController.errorMessage!,
                  style: AppTextStyles.body,
                ),
              )
            : wardrobeController.categories.isEmpty
            ? const Center(
                child: Text(
                  "No wardrobe categories available.",
                  style: AppTextStyles.body,
                ),
              )
            : ListView(
                children: wardrobeController.categories.map((category) {
                  final items = wardrobeController.getItemsByCategory(
                    category.id,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: _ClothingCategorySection(
                      category: category,
                      items: items,
                    ),
                  );
                }).toList(),
              ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: SizedBox(
            height: AppSpacing.xl,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'upload_clothing');
              },
              child: const Text("Upload Clothes"),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClothingCategorySection extends StatefulWidget {
  final WardrobeEntity category;
  final List<ClothItemEntity> items;

  const _ClothingCategorySection({required this.category, required this.items});

  @override
  State<_ClothingCategorySection> createState() =>
      _ClothingCategorySectionState();
}

class _ClothingCategorySectionState extends State<_ClothingCategorySection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = widget.items.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.category.categoryName, style: AppTextStyles.subtitle),

        const SizedBox(height: AppSpacing.md),

        if (!hasItems)
          const Text(
            "No clothing items in this category yet.",
            style: AppTextStyles.small,
          )
        else
          SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: false,
              thickness: AppSpacing.xs,
              radius: const Radius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final item = widget.items[index];

                    return SizedBox(
                      width: AppSpacing.xxxl + AppSpacing.sm,
                      height: AppSpacing.xxxl + AppSpacing.sm,
                      child: ClothingImageBox(
                        imagePath: item.photoPath,
                        isImageAvailable: item.isImageAvailable,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'clothing_detail',
                            arguments: item,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
