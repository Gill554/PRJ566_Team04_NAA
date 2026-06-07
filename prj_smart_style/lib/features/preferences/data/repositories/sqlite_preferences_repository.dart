import '../../domain/entities/preferences_color_entity.dart';
import '../../domain/entities/preferences_style_entity.dart';
import '../../domain/entities/user_profile_preferences_entity.dart';
import '../../domain/repositories/preferences_repository.dart';

import '../datasources/preferences_local_datasource.dart';

class SQLitePreferencesRepository implements PreferencesRepository {
  final PreferencesLocalDatasource localDatasource;

  const SQLitePreferencesRepository({required this.localDatasource});

  @override
  Future<List<PreferencesStyleEntity>> getPreferenceStyles() {
    return localDatasource.getPreferenceStyles();
  }

  @override
  Future<List<PreferencesColorEntity>> getPreferenceColors() {
    return localDatasource.getPreferenceColors();
  }

  @override
  Future<List<UserProfilePreferencesEntity>> getUserPreferenceProfiles({
    required String userId,
  }) {
    return localDatasource.getUserPreferenceProfiles(userId: userId);
  }

  @override
  Future<UserProfilePreferencesEntity> createUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  }) {
    return localDatasource.createUserPreferenceProfile(
      preferenceProfile: preferenceProfile,
    );
  }

  @override
  Future<UserProfilePreferencesEntity> updateUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  }) {
    return localDatasource.updateUserPreferenceProfile(
      preferenceProfile: preferenceProfile,
    );
  }

  @override
  Future<void> deleteUserPreferenceProfile({
    required String preferenceProfileId,
  }) {
    return localDatasource.deleteUserPreferenceProfile(
      preferenceProfileId: preferenceProfileId,
    );
  }
}
