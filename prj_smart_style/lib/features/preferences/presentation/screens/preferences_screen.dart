import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/preferences/domain/entities/user_profile_preferences_entity.dart';
import 'package:prj_smart_style/features/preferences/presentation/controllers/preferences_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().currentUser?.id;
      if (userId == null) return;
      context.read<PreferencesController>().loadProfiles(userId);
    });
  }

  Future<void> _openCreateScreen() async {
    await Navigator.pushNamed(context, 'edit_preferences');

    if (!mounted) return;

    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) return;
    context.read<PreferencesController>().loadProfiles(userId);
  }

  Future<void> _openEditScreen(UserProfilePreferencesEntity profile) async {
    await Navigator.pushNamed(context, 'edit_preferences', arguments: profile);

    if (!mounted) return;

    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) return;
    context.read<PreferencesController>().loadProfiles(userId);
  }

  void _confirmDelete(UserProfilePreferencesEntity profile) {
    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: "Delete Preference",
          description:
              "Are you sure you want to delete this preference profile?",
          confirmText: "Delete",
          isDanger: true,
          onConfirm: () {
            context.read<PreferencesController>().deleteProfile(profile.id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PreferencesController>();

    return Scaffold(
      appBar: const AppBackAppBar(title: "My Preference Profiles"),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.profiles.isEmpty
            ? const Center(
                child: Text(
                  "No preference profiles yet.",
                  style: AppTextStyles.body,
                ),
              )
            : ListView.separated(
                itemCount: controller.profiles.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.xl),
                itemBuilder: (context, index) {
                  final profile = controller.profiles[index];

                  return _PreferenceCard(
                    profile: profile,
                    onTap: () => _openEditScreen(profile),
                    onDelete: () => _confirmDelete(profile),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateScreen,
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: AppIcons.lg,
          color: AppColors.lightText,
        ),
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  final UserProfilePreferencesEntity profile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PreferenceCard({
    required this.profile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      margin: EdgeInsets.zero,
      color: AppColors.surfaceGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.profileName, style: AppTextStyles.subtitle),

                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      "Style: ${profile.preferencesStyle.title}",
                      style: AppTextStyles.small,
                    ),

                    Text(
                      "Color Palette: ${profile.preferencesColor.title}",
                      style: AppTextStyles.small,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  size: AppIcons.xl,
                  color: AppColors.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
