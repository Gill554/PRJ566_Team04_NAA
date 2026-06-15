import '../repositories/image_picker_repository.dart';

class TakePhotoUseCase {
  final ImagePickerRepository repository;

  const TakePhotoUseCase(this.repository);

  Future<String?> call() {
    return repository.takePhoto();
  }
}
