import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/repositories/image_picker_repository.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePicker imagePicker;

  const ImagePickerRepositoryImpl({required this.imagePicker});

  @override
  Future<String?> takePhoto() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return null;

    return _saveImagePermanently(image);
  }

  @override
  Future<String?> pickImageFromGallery() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return null;

    return _saveImagePermanently(image);
  }

  Future<String> _saveImagePermanently(XFile image) async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final clothingDirectory = Directory(
      path.join(appDirectory.path, 'clothing_images'),
    );

    if (!await clothingDirectory.exists()) {
      await clothingDirectory.create(recursive: true);
    }

    final extension = path.extension(image.path);
    final fileName =
        'clothing_${DateTime.now().millisecondsSinceEpoch}$extension';

    final savedImagePath = path.join(clothingDirectory.path, fileName);

    final savedImage = await File(image.path).copy(savedImagePath);

    return savedImage.path;
  }
}
