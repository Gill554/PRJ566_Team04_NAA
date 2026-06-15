import 'package:flutter/material.dart';
import '../../domain/entities/preferences_color_entity.dart';
import '../../domain/entities/preferences_style_entity.dart';
import '../../domain/entities/user_profile_preferences_entity.dart';
import '../../domain/usecases/create_user_preference_profile_usecase.dart';
import '../../domain/usecases/delete_user_preference_profile_usecase.dart';
import '../../domain/usecases/get_preference_colors_usecase.dart';
import '../../domain/usecases/get_preference_styles_usecase.dart';
import '../../domain/usecases/get_user_preference_profiles_usecase.dart';
import '../../domain/usecases/update_user_preference_profile_usecase.dart';

class PreferencesController extends ChangeNotifier {
  final GetPreferenceStylesUseCase getPreferenceStylesUseCase;
  final GetPreferenceColorsUseCase getPreferenceColorsUseCase;
  final GetUserPreferenceProfilesUseCase getUserPreferenceProfilesUseCase;
  final CreateUserPreferenceProfileUseCase createUserPreferenceProfileUseCase;
  final UpdateUserPreferenceProfileUseCase updateUserPreferenceProfileUseCase;
  final DeleteUserPreferenceProfileUseCase deleteUserPreferenceProfileUseCase;

  PreferencesController({
    required this.getPreferenceStylesUseCase,
    required this.getPreferenceColorsUseCase,
    required this.getUserPreferenceProfilesUseCase,
    required this.createUserPreferenceProfileUseCase,
    required this.updateUserPreferenceProfileUseCase,
    required this.deleteUserPreferenceProfileUseCase,
  });

  bool isLoading = false;
  String? errorMessage;

  List<PreferencesStyleEntity> styles = [];
  List<PreferencesColorEntity> colors = [];
  List<UserProfilePreferencesEntity> profiles = [];

  Future<void> loadOptions() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      styles = await getPreferenceStylesUseCase();
      colors = await getPreferenceColorsUseCase();
    } catch (e) {
      errorMessage = "Failed to load preference options";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProfiles(String userId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      profiles = await getUserPreferenceProfilesUseCase(userId: userId);
    } catch (e) {
      errorMessage = "Failed to load preference profiles";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createProfile(UserProfilePreferencesEntity profile) async {
    final createdProfile = await createUserPreferenceProfileUseCase(
      preferenceProfile: profile,
    );

    profiles.add(createdProfile);
    notifyListeners();
  }

  Future<void> updateProfile(UserProfilePreferencesEntity profile) async {
    final updatedProfile = await updateUserPreferenceProfileUseCase(
      preferenceProfile: profile,
    );

    final index = profiles.indexWhere((item) => item.id == updatedProfile.id);

    if (index != -1) {
      profiles[index] = updatedProfile;
      notifyListeners();
    }
  }

  Future<void> deleteProfile(String preferenceProfileId) async {
    await deleteUserPreferenceProfileUseCase(
      preferenceProfileId: preferenceProfileId,
    );

    profiles.removeWhere((profile) => profile.id == preferenceProfileId);
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
