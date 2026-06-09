import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/wardrobe/domain/entities/cloth_item_entity.dart';
import 'package:prj_smart_style/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';

class ClothingDetailScreen extends StatelessWidget {
  const ClothingDetailScreen({super.key});

  void _confirmDelete({
    required BuildContext context,
    required ClothItemEntity item,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Remove Item",
          description: "Are you sure you want to remove this clothing item?",
          confirmText: "Remove",
          cancelText: "Cancel",
          isDanger: true,
          onConfirm: () async {
            final userId = context.read<AuthController>().currentUser?.id;
            if (userId == null) return;

            await context.read<WardrobeController>().deleteClothingItem(
              userId: userId,
              clothItemId: item.id,
              wardrobeId: item.wardrobeId,
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

    if (args is! ClothItemEntity) {
      return Scaffold(
        appBar: const AppBackAppBar(title: "Clothing Detail"),

        body: const Center(child: Text("No clothing item selected.")),
      );
    }

    final item = args;

    final wardrobeController = context.watch<WardrobeController>();

    String categoryName = "Clothing Detail";

    for (final category in wardrobeController.categories) {
      if (category.id == item.wardrobeId) {
        categoryName = category.categoryName;
        break;
      }
    }

    return Scaffold(
      appBar: AppBackAppBar(title: categoryName),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),

            Expanded(
              child: ClothingImageBox(
                imagePath: item.photoPath,
                isImageAvailable: item.isImageAvailable,
              ),
            ),

            if (wardrobeController.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),

              Text(
                wardrobeController.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(color: Colors.red),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            PrimaryButton(
              text: wardrobeController.isLoading
                  ? "Removing..."
                  : "Remove Item",

              onPressed: wardrobeController.isLoading
                  ? null
                  : () {
                      _confirmDelete(context: context, item: item);
                    },
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
