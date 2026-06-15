import '../../domain/constants/preference_colors.dart';
import '../../domain/constants/preference_styles.dart';
import '../../domain/entities/user_profile_preferences_entity.dart';

class UserProfilePreferencesModel {
  final String id;
  final String profileName;
  final String description;
  final String userId;

  final String preferencesStyleId;
  final String preferencesColorId;

  const UserProfilePreferencesModel({
    required this.id,
    required this.profileName,
    required this.description,
    required this.userId,
    required this.preferencesStyleId,
    required this.preferencesColorId,
  });

  factory UserProfilePreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserProfilePreferencesModel(
      id: map['id'] as String,
      profileName: map['profileName'] as String,
      description: map['description'] as String,
      userId: map['userId'] as String,
      preferencesStyleId: map['preferencesStyleId'] as String,
      preferencesColorId: map['preferencesColorId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileName': profileName,
      'description': description,
      'userId': userId,
      'preferencesStyleId': preferencesStyleId,
      'preferencesColorId': preferencesColorId,
    };
  }

  factory UserProfilePreferencesModel.fromEntity(
    UserProfilePreferencesEntity entity,
  ) {
    return UserProfilePreferencesModel(
      id: entity.id,
      profileName: entity.profileName,
      description: entity.description,
      userId: entity.userId,
      preferencesStyleId: entity.preferencesStyle.id,
      preferencesColorId: entity.preferencesColor.id,
    );
  }

  UserProfilePreferencesEntity toEntity() {
    return UserProfilePreferencesEntity(
      id: id,
      profileName: profileName,
      description: description,
      userId: userId,
      preferencesStyle: PreferenceStyles.all.firstWhere(
        (style) => style.id == preferencesStyleId,
      ),
      preferencesColor: PreferenceColors.all.firstWhere(
        (color) => color.id == preferencesColorId,
      ),
    );
  }
}
