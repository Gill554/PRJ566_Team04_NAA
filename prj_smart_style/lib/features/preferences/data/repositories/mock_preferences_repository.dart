// import '../../domain/constants/preference_colors.dart';
// import '../../domain/constants/preference_styles.dart';
// import '../../domain/entities/preferences_color_entity.dart';
// import '../../domain/entities/preferences_style_entity.dart';
// import '../../domain/entities/user_profile_preferences_entity.dart';
// import '../../domain/repositories/preferences_repository.dart';

// class MockPreferencesRepository implements PreferencesRepository {
//   late final List<UserProfilePreferencesEntity> _profiles = [
//     UserProfilePreferencesEntity(
//       id: 'pref_001',
//       profileName: 'Formal Profile',
//       description: 'Ideal for interviews.',
//       userId: 'user_001',
//       preferencesStyle: PreferenceStyles.formal,
//       preferencesColor: PreferenceColors.neutral,
//     ),
//     UserProfilePreferencesEntity(
//       id: 'pref_002',
//       profileName: 'Work Profile',
//       description: 'For office and meetings.',
//       userId: 'user_001',
//       preferencesStyle: PreferenceStyles.professional,
//       preferencesColor: PreferenceColors.darkTones,
//     ),
//   ];

//   @override
//   Future<List<PreferencesStyleEntity>> getPreferenceStyles() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return PreferenceStyles.all;
//   }

//   @override
//   Future<List<PreferencesColorEntity>> getPreferenceColors() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return PreferenceColors.all;
//   }

//   @override
//   Future<List<UserProfilePreferencesEntity>> getUserPreferenceProfiles({
//     required String userId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return _profiles.where((profile) => profile.userId == userId).toList();
//   }

//   @override
//   Future<UserProfilePreferencesEntity> createUserPreferenceProfile({
//     required UserProfilePreferencesEntity preferenceProfile,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _profiles.add(preferenceProfile);
//     return preferenceProfile;
//   }

//   @override
//   Future<UserProfilePreferencesEntity> updateUserPreferenceProfile({
//     required UserProfilePreferencesEntity preferenceProfile,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     final index = _profiles.indexWhere(
//       (profile) => profile.id == preferenceProfile.id,
//     );

//     if (index == -1) {
//       throw Exception('Preference profile not found');
//     }

//     _profiles[index] = preferenceProfile;
//     return preferenceProfile;
//   }

//   @override
//   Future<void> deleteUserPreferenceProfile({
//     required String preferenceProfileId,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 300));

//     _profiles.removeWhere((profile) => profile.id == preferenceProfileId);
//   }
// }
