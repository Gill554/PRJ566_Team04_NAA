import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/preferences/domain/entities/preferences_color_entity.dart';
import 'package:prj_smart_style/features/preferences/domain/entities/preferences_style_entity.dart';
import 'package:prj_smart_style/features/preferences/domain/entities/user_profile_preferences_entity.dart';
import 'package:prj_smart_style/features/preferences/domain/validators/preferences_validators.dart';
import 'package:prj_smart_style/features/preferences/presentation/controllers/preferences_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/app_confirmation_dialog.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/secondary_button.dart';

class EditPreferencesScreen extends StatefulWidget {
  const EditPreferencesScreen({super.key});

  @override
  State<EditPreferencesScreen> createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  final profileNameController = TextEditingController();
  final descriptionController = TextEditingController();

  UserProfilePreferencesEntity? editingProfile;

  PreferencesStyleEntity? selectedStyle;
  PreferencesColorEntity? selectedColorPalette;

  bool hasLoadedInitialData = false;
  String? localErrorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesController>().loadOptions();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (hasLoadedInitialData) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is UserProfilePreferencesEntity) {
      editingProfile = args;
      profileNameController.text = args.profileName;
      descriptionController.text = args.description;
      selectedStyle = args.preferencesStyle;
      selectedColorPalette = args.preferencesColor;
    }

    hasLoadedInitialData = true;
  }

  @override
  void dispose() {
    profileNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String? _getValidationError() {
    return PreferencesValidators.validateProfileName(
          profileNameController.text,
        ) ??
        PreferencesValidators.validateDescription(descriptionController.text) ??
        PreferencesValidators.validateStyle(selectedStyle) ??
        PreferencesValidators.validateColorPalette(selectedColorPalette);
  }

  bool _validateForm() {
    final validationError = _getValidationError();

    setState(() {
      localErrorMessage = validationError;
    });

    return validationError == null;
  }

  Future<void> _handleSave() async {
    final preferencesController = context.read<PreferencesController>();
    final authController = context.read<AuthController>();

    final userId = authController.currentUser?.id;
    if (userId == null) return;

    final profile = UserProfilePreferencesEntity(
      id: editingProfile?.id ?? 'pref_${DateTime.now().millisecondsSinceEpoch}',
      profileName: profileNameController.text.trim(),
      description: descriptionController.text.trim(),
      userId: editingProfile?.userId ?? userId,
      preferencesStyle: selectedStyle!,
      preferencesColor: selectedColorPalette!,
    );

    if (editingProfile == null) {
      await preferencesController.createProfile(profile);
    } else {
      await preferencesController.updateProfile(profile);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showSaveConfirmation() {
    if (!_validateForm()) return;

    showDialog(
      context: context,
      builder: (_) {
        return AppConfirmationDialog(
          title: editingProfile == null ? "Create Preference" : "Save Changes",
          description: editingProfile == null
              ? "Are you sure you want to create this preference profile?"
              : "Are you sure you want to update this preference profile?",
          confirmText: editingProfile == null ? "Create" : "Save",
          cancelText: "Cancel",
          onConfirm: _handleSave,
        );
      },
    );
  }

  void _clearErrors() {
    setState(() {
      localErrorMessage = null;
    });

    context.read<PreferencesController>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesController = context.watch<PreferencesController>();
    final isEditing = editingProfile != null;

    return Scaffold(
      appBar: AppBackAppBar(
        title: isEditing ? "Edit My Preferences" : "Create Preferences",
      ),
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
              const _FieldLabel(text: "Profile Name"),
              const SizedBox(height: AppSpacing.xs),
              _AppTextField(
                controller: profileNameController,
                hintText: "Give this profile a memorable name",
                onChanged: (_) {
                  _clearErrors();
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              const _FieldLabel(text: "Description"),
              const SizedBox(height: AppSpacing.xs),
              _AppTextAreaField(
                controller: descriptionController,
                hintText:
                    "Add a short description to remember this profile later",
                onChanged: (_) {
                  _clearErrors();
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              const _FieldLabel(text: "Preferred Style"),
              const SizedBox(height: AppSpacing.xs),
              _AppDropdownField<PreferencesStyleEntity>(
                value: selectedStyle,
                hintText: "Select",
                options: preferencesController.styles,
                getLabel: (item) => item.title,
                onChanged: (value) {
                  setState(() {
                    selectedStyle = value;
                  });

                  _clearErrors();
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              const _FieldLabel(text: "Preferred Color Palette"),
              const SizedBox(height: AppSpacing.xs),
              _AppDropdownField<PreferencesColorEntity>(
                value: selectedColorPalette,
                hintText: "Select",
                options: preferencesController.colors,
                getLabel: (item) => item.title,
                onChanged: (value) {
                  setState(() {
                    selectedColorPalette = value;
                  });

                  _clearErrors();
                },
              ),

              if (localErrorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  localErrorMessage!,
                  style: AppTextStyles.small.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],

              if (preferencesController.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  preferencesController.errorMessage!,
                  style: AppTextStyles.small.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: AppSpacing.xxl),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: PrimaryButton(
                  text: preferencesController.isLoading
                      ? "Loading..."
                      : isEditing
                      ? "Save Changes"
                      : "Create New Profile",
                  onPressed: preferencesController.isLoading
                      ? null
                      : _showSaveConfirmation,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                child: SecondaryButton(
                  text: "Cancel",
                  onPressed: preferencesController.isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.subtitle);
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const _AppTextField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

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
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _AppTextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const _AppTextAreaField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.xxxl,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<T> options;
  final String Function(T item) getLabel;
  final ValueChanged<T?> onChanged;

  const _AppDropdownField({
    required this.value,
    required this.hintText,
    required this.options,
    required this.getLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceGray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(hintText, style: AppTextStyles.body),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: options.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(getLabel(option), style: AppTextStyles.body),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
