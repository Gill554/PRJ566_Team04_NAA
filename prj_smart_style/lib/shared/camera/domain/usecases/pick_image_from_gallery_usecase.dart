import '../repositories/image_picker_repository.dart';

class PickImageFromGalleryUseCase {
  final ImagePickerRepository repository;

  const PickImageFromGalleryUseCase(this.repository);

  Future<String?> call() {
    return repository.pickImageFromGallery();
  }
}
