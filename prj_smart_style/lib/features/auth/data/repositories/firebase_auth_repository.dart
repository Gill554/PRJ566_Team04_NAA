import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  const FirebaseAuthRepository({required this.firebaseAuth});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return _mapFirebaseUserToEntity(user);
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("Login failed. Please try again.");
      }

      return _mapFirebaseUserToEntity(user);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception("Account creation failed. Please try again.");
      }

      await user.updateDisplayName(fullName);
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception("Account created, but user data could not be loaded.");
      }

      return _mapFirebaseUserToEntity(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserEntity> updateUserName({required String fullName}) async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      await user.updateDisplayName(fullName);
      await user.reload();

      final updatedUser = firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception("Updated user could not be loaded.");
      }

      return _mapFirebaseUserToEntity(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e));
    }
  }

  UserEntity _mapFirebaseUserToEntity(User user) {
    return UserEntity(
      id: user.uid,
      fullName: user.displayName ?? "Unknown User",
      email: user.email ?? "",
    );
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        return "Please enter a valid email address.";
      case "user-disabled":
        return "This account has been disabled.";
      case "user-not-found":
      case "wrong-password":
      case "invalid-credential":
        return "Invalid email or password.";
      case "email-already-in-use":
        return "An account already exists with this email.";
      case "weak-password":
        return "Please use a stronger password.";
      case "operation-not-allowed":
        return "Email and password sign-in is not enabled.";
      case "network-request-failed":
        return "Network error. Please check your internet connection.";
      default:
        return "Authentication failed. Please try again.";
    }
  }
}
