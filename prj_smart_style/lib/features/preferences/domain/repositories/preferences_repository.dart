import '../entities/preferences_color_entity.dart';
import '../entities/preferences_style_entity.dart';
import '../entities/user_profile_preferences_entity.dart';

abstract class PreferencesRepository {
  Future<List<PreferencesStyleEntity>> getPreferenceStyles();

  Future<List<PreferencesColorEntity>> getPreferenceColors();

  Future<List<UserProfilePreferencesEntity>> getUserPreferenceProfiles({
    required String userId,
  });

  Future<UserProfilePreferencesEntity> createUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  });

  Future<UserProfilePreferencesEntity> updateUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  });

  Future<void> deleteUserPreferenceProfile({
    required String preferenceProfileId,
  });
}
