class AuthValidators {
  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Invalid email format";
    }

    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must contain at least 8 characters";
    }

    final upperCaseRegex = RegExp(r'[A-Z]');
    if (!upperCaseRegex.hasMatch(value)) {
      return "Password must contain an uppercase letter";
    }

    final lowerCaseRegex = RegExp(r'[a-z]');
    if (!lowerCaseRegex.hasMatch(value)) {
      return "Password must contain a lowercase letter";
    }

    final numberRegex = RegExp(r'[0-9]');
    if (!numberRegex.hasMatch(value)) {
      return "Password must contain a number";
    }

    final specialRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialRegex.hasMatch(value)) {
      return "Password must contain a special character";
    }

    return null;
  }

  static String? validateName(String value) {
    if (value.trim().isEmpty) {
      return "Name is required";
    }

    if (value.trim().length < 2) {
      return "Name is too short";
    }

    return null;
  }

  static String? validateLoginPassword(String value) {
    if (value.trim().isEmpty) {
      return "Password is required";
    }

    return null;
  }

  static String? validateConfirmPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.trim().isEmpty) {
      return "Please confirm your password";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }
}
