import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;

  final String confirmText;
  final String cancelText;

  final VoidCallback onConfirm;

  final bool isDanger;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),

      title: Text(title, style: AppTextStyles.subtitle),

      content: Text(description, style: AppTextStyles.body),

      actionsPadding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderSoft),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text(
                  cancelText,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDanger
                      ? AppColors.delete
                      : AppColors.primary,

                  foregroundColor: AppColors.lightText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },

                child: Text(confirmText, style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
