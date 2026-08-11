import 'package:flutter/material.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/user_initial_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Log Out",
          description: "Are you sure you want to log out?",
          confirmText: "Log Out",
          cancelText: "Cancel",
          onConfirm: () async {
            final authController = context.read<AuthController>();
            await authController.logout();
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              'login',
              (route) => false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: const AppBackAppBar(title: "My Profile"),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(
                fullName:
                    authController.currentUser?.fullName ?? "Unknown User",
                email: authController.currentUser?.email ?? "No email",
              ),

              const SizedBox(height: AppSpacing.xl),

              _ProfileActionTile(
                icon: Icons.person_outline,
                label: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, 'edit_profile');
                },
              ),

              const SizedBox(height: AppSpacing.md),

              _ProfileActionTile(
                icon: Icons.favorite_border,
                label: "Preferences",
                isPrimary: true,
                onTap: () {
                  Navigator.pushNamed(context, 'preferences');
                },
              ),

              const Spacer(),

              PrimaryButton(text: "Log Out", onPressed: _handleLogout),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;

  const _ProfileHeader({required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserInitialAvatar(fullName: fullName, radius: AppRadius.xl),

        const SizedBox(width: AppSpacing.lg),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: AppTextStyles.title,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                email,
                style: AppTextStyles.body,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary ? Colors.black : AppColors.surfaceGray;
    final contentColor = isPrimary ? Colors.white : Colors.black;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(icon, color: contentColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: contentColor),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppIcons.md,
              color: contentColor,
            ),
          ],
        ),
      ),
    );
  }
}
