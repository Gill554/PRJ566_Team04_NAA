import 'package:prj_smart_style/shared/local_database/database_service.dart';
import 'package:prj_smart_style/shared/local_database/database_tables.dart';

import '../models/user_profile_preferences_model.dart';
import '../../domain/constants/preference_colors.dart';
import '../../domain/constants/preference_styles.dart';
import '../../domain/entities/preferences_color_entity.dart';
import '../../domain/entities/preferences_style_entity.dart';
import '../../domain/entities/user_profile_preferences_entity.dart';

class PreferencesLocalDatasource {
  final DatabaseService databaseService;

  const PreferencesLocalDatasource({required this.databaseService});

  Future<List<PreferencesStyleEntity>> getPreferenceStyles() async {
    return PreferenceStyles.all;
  }

  Future<List<PreferencesColorEntity>> getPreferenceColors() async {
    return PreferenceColors.all;
  }

  Future<List<UserProfilePreferencesEntity>> getUserPreferenceProfiles({
    required String userId,
  }) async {
    final rows = await databaseService.query(
      table: DatabaseTables.preferenceProfiles,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'profileName ASC',
    );

    return rows.map((row) {
      return UserProfilePreferencesModel.fromMap(row).toEntity();
    }).toList();
  }

  Future<UserProfilePreferencesEntity> createUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  }) async {
    final model = UserProfilePreferencesModel.fromEntity(preferenceProfile);

    await databaseService.insert(
      table: DatabaseTables.preferenceProfiles,
      values: model.toMap(),
    );

    return model.toEntity();
  }

  Future<UserProfilePreferencesEntity> updateUserPreferenceProfile({
    required UserProfilePreferencesEntity preferenceProfile,
  }) async {
    final model = UserProfilePreferencesModel.fromEntity(preferenceProfile);

    await databaseService.update(
      table: DatabaseTables.preferenceProfiles,
      values: model.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [model.id, model.userId],
    );

    return model.toEntity();
  }

  Future<void> deleteUserPreferenceProfile({
    required String preferenceProfileId,
  }) async {
    await databaseService.delete(
      table: DatabaseTables.preferenceProfiles,
      where: 'id = ?',
      whereArgs: [preferenceProfileId],
    );
  }
}
