import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:prj_smart_style/shared/camera/domain/usecases/take_photo_usecase.dart';
import 'package:prj_smart_style/shared/widgets/app_back_app_bar.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/secondary_button.dart';
import 'package:prj_smart_style/shared/camera/domain/usecases/pick_image_from_gallery_usecase.dart';
import 'package:prj_smart_style/shared/widgets/clothing_image_box.dart';

enum UploadStep {
  initial,
  takingPicture,
  acceptPicture,
  uploading,
  completed,
  error,
}

class UploadClothingScreen extends StatefulWidget {
  const UploadClothingScreen({super.key});

  @override
  State<UploadClothingScreen> createState() => _UploadClothingScreenState();
}

class _UploadClothingScreenState extends State<UploadClothingScreen> {
  UploadStep currentStep = UploadStep.initial;

  String? imagePath;
  String? localErrorMessage;

  void _goTo(UploadStep step) {
    setState(() {
      currentStep = step;
    });
  }

  Future<void> _handleTakePhoto() async {
    _goTo(UploadStep.takingPicture);

    final takePhotoUseCase = context.read<TakePhotoUseCase>();

    final path = await takePhotoUseCase();

    if (!mounted) return;

    if (path == null || path.trim().isEmpty) {
      setState(() {
        localErrorMessage = "No image was selected.";
        currentStep = UploadStep.error;
      });
      return;
    }

    setState(() {
      imagePath = path;
      localErrorMessage = null;
      currentStep = UploadStep.acceptPicture;
    });
  }

  Future<void> _handlePickFromGallery() async {
    _goTo(UploadStep.takingPicture);

    final pickImageFromGalleryUseCase = context
        .read<PickImageFromGalleryUseCase>();

    final path = await pickImageFromGalleryUseCase();

    if (!mounted) return;

    if (path == null || path.trim().isEmpty) {
      setState(() {
        localErrorMessage = "No image was selected.";
        currentStep = UploadStep.error;
      });
      return;
    }

    setState(() {
      imagePath = path;
      localErrorMessage = null;
      currentStep = UploadStep.acceptPicture;
    });
  }

  Future<void> _handleUpload() async {
    if (imagePath == null) {
      setState(() {
        localErrorMessage = "No image was selected.";
        currentStep = UploadStep.error;
      });
      return;
    }

    _goTo(UploadStep.uploading);

    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) return;

    final success = await context
        .read<WardrobeController>()
        .analyzeAndAddClothingItem(userId: userId, imagePath: imagePath!);

    if (!mounted) return;

    if (success) {
      _goTo(UploadStep.completed);
    } else {
      setState(() {
        localErrorMessage = context.read<WardrobeController>().errorMessage;
        currentStep = UploadStep.error;
      });
    }
  }

  void _clearUpload() {
    setState(() {
      imagePath = null;
      localErrorMessage = null;
      currentStep = UploadStep.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackAppBar(title: "Upload Photo"),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Upload a photo of your desired clothing.",
              style: AppTextStyles.small,
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(child: _buildStepContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case UploadStep.initial:
        return _InitialUploadStep(
          onTakePhoto: _handleTakePhoto,
          onPickFromGallery: _handlePickFromGallery,
        );

      case UploadStep.takingPicture:
        return const _TakingPictureStep();

      case UploadStep.acceptPicture:
        return _AcceptPictureStep(
          imagePath: imagePath,
          onUpload: _handleUpload,
          onRetake: _handleTakePhoto,
          onPickAnother: _handlePickFromGallery,
        );

      case UploadStep.uploading:
        return const _UploadingStep();

      case UploadStep.completed:
        return _CompletedStep(
          onClear: _clearUpload,
          onBackToWardrobe: () {
            Navigator.pop(context);
          },
        );

      case UploadStep.error:
        return _UploadErrorStep(
          message: localErrorMessage ?? "Something went wrong.",
          onRetry: _handleUpload,
          onClear: _clearUpload,
        );
    }
  }
}

class _InitialUploadStep extends StatelessWidget {
  final VoidCallback onTakePhoto;
  final VoidCallback onPickFromGallery;

  const _InitialUploadStep({
    required this.onTakePhoto,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderSoft),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_photo_alternate_outlined, size: AppIcons.xxl),
            const SizedBox(height: AppSpacing.md),
            const Text("Upload a clothing photo", style: AppTextStyles.body),
            const Text("PNG or JPG", style: AppTextStyles.small),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              child: PrimaryButton(
                text: "Take a Photo",
                onPressed: onTakePhoto,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              child: SecondaryButton(
                text: "Choose from Gallery",
                onPressed: onPickFromGallery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TakingPictureStep extends StatelessWidget {
  const _TakingPictureStep();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _AcceptPictureStep extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onUpload;
  final VoidCallback onRetake;
  final VoidCallback onPickAnother;

  const _AcceptPictureStep({
    required this.imagePath,
    required this.onUpload,
    required this.onRetake,
    required this.onPickAnother,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: hasImage
              ? ClothingImageBox(imagePath: imagePath!, isImageAvailable: true)
              : Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined, size: AppIcons.xl),
                  ),
                ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Row(
          children: [
            Expanded(
              child: PrimaryButton(text: "UPLOAD", onPressed: onUpload),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SecondaryButton(text: "RETAKE", onPressed: onRetake),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        SecondaryButton(text: "Choose Another Photo", onPressed: onPickAnother),
      ],
    );
  }
}

class _UploadingStep extends StatelessWidget {
  const _UploadingStep();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderSoft),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file_outlined, size: AppIcons.xl),
            SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text(
              "Analyzing and uploading photo...",
              style: AppTextStyles.small,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedStep extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onBackToWardrobe;

  const _CompletedStep({required this.onClear, required this.onBackToWardrobe});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderSoft),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: AppIcons.xl,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text("Upload Complete", style: AppTextStyles.body),
            const Text(
              "Your clothing item was saved successfully.",
              style: AppTextStyles.small,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              child: PrimaryButton(
                text: "Back to Wardrobe",
                onPressed: onBackToWardrobe,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              child: SecondaryButton(
                text: "Upload Another Item",
                onPressed: onClear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadErrorStep extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onClear;

  const _UploadErrorStep({
    required this.message,
    required this.onRetry,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderSoft),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: AppIcons.xl,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text("Upload Failed", style: AppTextStyles.subtitle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.small,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              child: PrimaryButton(text: "Retry", onPressed: onRetry),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              child: SecondaryButton(text: "Clear Upload", onPressed: onClear),
            ),
          ],
        ),
      ),
    );
  }
}
