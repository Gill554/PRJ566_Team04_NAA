import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/outfit/domain/entities/outfit_details_entity.dart';
import 'package:prj_smart_style/features/outfit/domain/validators/outfit_request_validators.dart';
import 'package:prj_smart_style/features/outfit/domain/usecases/prepare_outfit_input_usecase.dart';
import 'package:prj_smart_style/features/outfit/presentation/controllers/outfit_controller.dart';
import 'package:prj_smart_style/features/preferences/domain/entities/user_profile_preferences_entity.dart';
import 'package:prj_smart_style/features/preferences/presentation/controllers/preferences_controller.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';

class OutfitRequestScreen extends StatefulWidget {
  const OutfitRequestScreen({super.key});

  @override
  State<OutfitRequestScreen> createState() => _OutfitRequestScreenState();
}

class _OutfitRequestScreenState extends State<OutfitRequestScreen> {
  static const List<String> weatherOptions = ["Sunny", "Rainy", "Cold", "Hot"];

  final occasionController = TextEditingController();

  UserProfilePreferencesEntity? selectedProfile;
  String? selectedWeather;
  String? localErrorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthController>().currentUser?.id;
      if (userId == null) return;

      context.read<PreferencesController>().loadProfiles(userId);
    });
  }

  @override
  void dispose() {
    occasionController.dispose();
    super.dispose();
  }

  String? _getValidationError() {
    return OutfitRequestValidators.validatePreferenceProfile(selectedProfile) ??
        OutfitRequestValidators.validateWeather(selectedWeather) ??
        OutfitRequestValidators.validateOccasion(occasionController.text);
  }

  Future<void> _handleGenerate() async {
    final validationError = _getValidationError();

    if (validationError != null) {
      setState(() {
        localErrorMessage = validationError;
      });
      return;
    }

    setState(() {
      localErrorMessage = null;
    });

    final authController = context.read<AuthController>();
    final prepareOutfitInputUseCase = context.read<PrepareOutfitInputUseCase>();
    final outfitController = context.read<OutfitController>();

    final userId = authController.currentUser?.id;
    if (userId == null) return;

    final details = OutfitDetailsEntity(
      id: 'details_${DateTime.now().millisecondsSinceEpoch}',
      userProfilePreferences: selectedProfile!,
      occasion: occasionController.text.trim(),
      weather: selectedWeather!,
    );

    try {
      final input = await prepareOutfitInputUseCase.call(
        userId: userId,
        details: details,
      );

      if (!mounted) return;

      await outfitController.generateRecommendations(input: input);

      if (!mounted) return;

      Navigator.pushNamed(context, 'outfit_result');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        localErrorMessage = e.toString().replaceFirst("Exception: ", "");
      });
    }
  }

  void _clearErrors() {
    setState(() {
      localErrorMessage = null;
    });

    context.read<OutfitController>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesController = context.watch<PreferencesController>();
    final outfitController = context.watch<OutfitController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppBackAppBar(title: "Outfit Recommendation"),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel(text: "Preference Profile"),
                    const SizedBox(height: AppSpacing.xs),

                    preferencesController.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _ProfileDropdownField(
                            value: selectedProfile,
                            hint: "Select a profile",
                            items: preferencesController.profiles,
                            onChanged: (value) {
                              setState(() {
                                selectedProfile = value;
                              });
                              _clearErrors();
                            },
                          ),

                    const SizedBox(height: AppSpacing.lg),

                    const _FieldLabel(text: "Weather"),
                    const SizedBox(height: AppSpacing.xs),
                    _DropdownField(
                      value: selectedWeather,
                      hint: "Select weather",
                      items: weatherOptions,
                      onChanged: (value) {
                        setState(() {
                          selectedWeather = value;
                        });
                        _clearErrors();
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    const _FieldLabel(
                      text: "Provide a description of the occasion",
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _TextAreaField(
                      controller: occasionController,
                      onChanged: (_) {
                        _clearErrors();
                      },
                    ),

                    if (localErrorMessage != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        localErrorMessage!,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    if (outfitController.errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        outfitController.errorMessage!,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              PrimaryButton(
                text: outfitController.isLoading
                    ? "Generating..."
                    : "Generate Outfit Recommendation",
                onPressed: outfitController.isLoading ? null : _handleGenerate,
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

class _ProfileDropdownField extends StatelessWidget {
  final UserProfilePreferencesEntity? value;
  final String hint;
  final List<UserProfilePreferencesEntity> items;
  final ValueChanged<UserProfilePreferencesEntity?> onChanged;

  const _ProfileDropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    UserProfilePreferencesEntity? currentValue;

    if (value != null) {
      for (final item in items) {
        if (item.id == value!.id) {
          currentValue = item;
          break;
        }
      }
    }

    return DropdownButtonFormField<UserProfilePreferencesEntity>(
      initialValue: currentValue,
      isExpanded: true,

      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.profileName,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
      ),

      hint: Text(hint, style: AppTextStyles.body),

      icon: const Icon(Icons.keyboard_arrow_down),

      items: items.map((item) {
        return DropdownMenuItem<UserProfilePreferencesEntity>(
          value: item,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.profileName, style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.description,
                style: AppTextStyles.small,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),

      onChanged: onChanged,
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
      ),
      hint: Text(hint, style: AppTextStyles.body),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: AppTextStyles.body),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  const _TextAreaField({required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Example: dinner, interview, school presentation...",
        hintStyle: AppTextStyles.small,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
