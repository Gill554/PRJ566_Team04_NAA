import 'package:prj_smart_style/features/preferences/domain/entities/user_profile_preferences_entity.dart';

class OutfitRequestValidators {
  static String? validatePreferenceProfile(
    UserProfilePreferencesEntity? value,
  ) {
    if (value == null) {
      return "Preference profile is required";
    }

    return null;
  }

  static String? validateWeather(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Weather is required";
    }

    return null;
  }

  static String? validateOccasion(String value) {
    if (value.trim().isEmpty) {
      return "Occasion description is required";
    }

    return null;
  }
}
