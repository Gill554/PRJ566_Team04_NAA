import '../entities/user_profile_preferences_entity.dart';
import '../repositories/preferences_repository.dart';

class UpdateUserPreferenceProfileUseCase {
  final PreferencesRepository repository;

  const UpdateUserPreferenceProfileUseCase(this.repository);

  Future<UserProfilePreferencesEntity> call({
    required UserProfilePreferencesEntity preferenceProfile,
  }) {
    return repository.updateUserPreferenceProfile(
      preferenceProfile: preferenceProfile,
    );
  }
}
