import 'package:flutter/material.dart';
import 'package:prj_smart_style/features/auth/domain/usecases/update_user_name_usecase.dart';
import 'package:prj_smart_style/features/auth/domain/validators/auth_validators.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateUserNameUseCase updateUserNameUseCase;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserNameUseCase,
  });

  bool isLoading = false;
  String? errorMessage;
  UserEntity? currentUser;

  Future<bool> login({required String email, required String password}) async {
    final emailError = AuthValidators.validateEmail(email);
    final passwordError = AuthValidators.validateLoginPassword(password);

    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }

    if (passwordError != null) {
      errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await loginUseCase(email: email, password: password);

      return true;
    } catch (e) {
      errorMessage = "Invalid email or password";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    final nameError = AuthValidators.validateName(fullName);
    final emailError = AuthValidators.validateEmail(email);
    final passwordError = AuthValidators.validatePassword(password);
    final confirmPasswordError = AuthValidators.validateConfirmPassword(
      password: password,
      confirmPassword: confirmPassword,
    );

    if (nameError != null) {
      errorMessage = nameError;
      notifyListeners();
      return false;
    }

    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }

    if (passwordError != null) {
      errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    if (confirmPasswordError != null) {
      errorMessage = confirmPasswordError;
      notifyListeners();
      return false;
    }

    if (!acceptedTerms) {
      errorMessage = "You must accept the Terms Of Use & Privacy Policy";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      errorMessage = "Registration failed";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await logoutUseCase();

    currentUser = null;

    notifyListeners();
  }

  Future<bool> updateUserName({required String fullName}) async {
    final nameError = AuthValidators.validateName(fullName);

    if (nameError != null) {
      errorMessage = nameError;
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await updateUserNameUseCase(
        userId: currentUser!.id,
        fullName: fullName.trim(),
      );

      return true;
    } catch (e) {
      errorMessage = "Failed to update profile";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> initializeAuthSession() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await getCurrentUserUseCase();
    } catch (e) {
      currentUser = null;
      errorMessage = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
