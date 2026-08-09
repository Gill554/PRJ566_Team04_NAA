import '../../../preferences/domain/entities/user_profile_preferences_entity.dart';

class OutfitDetailsEntity {
  final String id;
  final UserProfilePreferencesEntity userProfilePreferences;
  final String occasion;
  final String weather;

  const OutfitDetailsEntity({
    required this.id,
    required this.userProfilePreferences,
    required this.occasion,
    required this.weather,
  });
}
