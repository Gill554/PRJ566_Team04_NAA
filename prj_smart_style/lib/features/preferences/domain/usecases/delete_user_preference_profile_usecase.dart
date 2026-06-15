import '../repositories/preferences_repository.dart';

class DeleteUserPreferenceProfileUseCase {
  final PreferencesRepository repository;

  const DeleteUserPreferenceProfileUseCase(this.repository);

  Future<void> call({required String preferenceProfileId}) {
    return repository.deleteUserPreferenceProfile(
      preferenceProfileId: preferenceProfileId,
    );
  }
}
