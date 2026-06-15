import '../entities/user_profile_preferences_entity.dart';
import '../repositories/preferences_repository.dart';

class GetUserPreferenceProfilesUseCase {
  final PreferencesRepository repository;

  const GetUserPreferenceProfilesUseCase(this.repository);

  Future<List<UserProfilePreferencesEntity>> call({required String userId}) {
    return repository.getUserPreferenceProfiles(userId: userId);
  }
}
