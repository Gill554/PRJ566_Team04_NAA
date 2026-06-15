abstract class ImagePickerRepository {
  Future<String?> takePhoto();

  Future<String?> pickImageFromGallery();
}
