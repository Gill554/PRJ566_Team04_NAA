import '../entities/preferences_color_entity.dart';
import '../entities/preferences_style_entity.dart';

class PreferencesValidators {
  static String? validateProfileName(String value) {
    if (value.trim().isEmpty) {
      return "Profile name is required";
    }

    return null;
  }

  static String? validateDescription(String value) {
    if (value.trim().isEmpty) {
      return "Description is required";
    }

    return null;
  }

  static String? validateStyle(PreferencesStyleEntity? value) {
    if (value == null) {
      return "Preferred style is required";
    }

    return null;
  }

  static String? validateColorPalette(PreferencesColorEntity? value) {
    if (value == null) {
      return "Preferred color palette is required";
    }

    return null;
  }
}
