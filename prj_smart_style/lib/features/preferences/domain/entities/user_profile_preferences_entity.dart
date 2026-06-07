import 'preferences_style_entity.dart';
import 'preferences_color_entity.dart';

class UserProfilePreferencesEntity {
  final String id;
  final String profileName;
  final String description;
  final String userId;
  final PreferencesStyleEntity preferencesStyle;
  final PreferencesColorEntity preferencesColor;

  const UserProfilePreferencesEntity({
    required this.id,
    required this.profileName,
    required this.description,
    required this.userId,
    required this.preferencesStyle,
    required this.preferencesColor,
  });
}
