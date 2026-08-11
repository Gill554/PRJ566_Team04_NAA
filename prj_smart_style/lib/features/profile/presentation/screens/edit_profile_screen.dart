import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/domain/validators/auth_validators.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/secondary_button.dart';
import 'package:prj_smart_style/shared/widgets/user_initial_avatar.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final fullNameController = TextEditingController();
  String? localErrorMessage;

  @override
  void initState() {
    super.initState();

    final user = context.read<AuthController>().currentUser;
    fullNameController.text = user?.fullName ?? "";
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final fullName = fullNameController.text.trim();

    final validationError = AuthValidators.validateName(fullName);

    if (validationError != null) {
      setState(() {
        localErrorMessage = validationError;
      });
      return;
    }

    setState(() {
      localErrorMessage = null;
    });

    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Save Changes",
          description: "Are you sure you want to update your profile name?",
          confirmText: "Save",
          cancelText: "Cancel",
          onConfirm: () async {
            final authController = context.read<AuthController>();

            final success = await authController.updateUserName(
              fullName: fullName,
            );

            if (!mounted) return;

            if (success) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    return Scaffold(
      appBar: const AppBackAppBar(title: "Edit Profile"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EditProfileHeader(fullName: user?.fullName ?? "Unknown User"),

              const SizedBox(height: AppSpacing.lg),

              const _ProfileInputLabel(text: "Full Name"),
              const SizedBox(height: AppSpacing.xs),

              _ProfileTextField(
                controller: fullNameController,
                onChanged: () {
                  if (localErrorMessage != null) {
                    setState(() {
                      localErrorMessage = null;
                    });
                  }
                  context.read<AuthController>().clearError();
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // const _ProfileInputLabel(text: "Email Address"),
              // const SizedBox(height: AppSpacing.xs),

              // _ReadOnlyProfileField(text: user?.email ?? "No email"),
              if (authController.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  authController.errorMessage!,
                  style: AppTextStyles.small.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],

              if (localErrorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  localErrorMessage!,
                  style: AppTextStyles.small.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: PrimaryButton(
                  text: authController.isLoading ? "Saving..." : "Save Changes",
                  onPressed: authController.isLoading ? null : _handleSave,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: SecondaryButton(
                  text: "Cancel",
                  onPressed: authController.isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  final String fullName;

  const _EditProfileHeader({required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserInitialAvatar(fullName: fullName, radius: AppRadius.xxl),

        const SizedBox(height: AppSpacing.md),

        Text(
          fullName,
          style: AppTextStyles.avatarName,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileInputLabel extends StatelessWidget {
  final String text;
  const _ProfileInputLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.body);
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const _ProfileTextField({required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: TextField(
        controller: controller,

        onChanged: (_) {
          onChanged?.call();
        },

        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}

// class _ReadOnlyProfileField extends StatelessWidget {
//   final String text;
//   const _ReadOnlyProfileField({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSpacing.sm,
//         vertical: AppSpacing.xs,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceGray,
//         borderRadius: BorderRadius.circular(AppRadius.sm),
//       ),
//       child: Text(text, style: AppTextStyles.body),
//     );
//   }
// }
