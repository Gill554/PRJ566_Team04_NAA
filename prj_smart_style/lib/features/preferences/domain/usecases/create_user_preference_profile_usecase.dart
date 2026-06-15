import '../entities/user_profile_preferences_entity.dart';
import '../repositories/preferences_repository.dart';

class CreateUserPreferenceProfileUseCase {
  final PreferencesRepository repository;

  const CreateUserPreferenceProfileUseCase(this.repository);

  Future<UserProfilePreferencesEntity> call({
    required UserProfilePreferencesEntity preferenceProfile,
  }) {
    return repository.createUserPreferenceProfile(
      preferenceProfile: preferenceProfile,
    );
  }
}
