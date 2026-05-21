import 'package:flutter/material.dart';
import 'export_routes.dart';

class Routes {
  static const initialRoute = 'auth_gate';
  static Map<String, Widget Function(BuildContext)> routes = {
    'auth_gate': (_) => const AuthGateScreen(),
    'login': (BuildContext context) => const LoginScreen(),
    'registration': (BuildContext context) => const RegistrationScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'profile': (BuildContext context) => const ProfileScreen(),
    'edit_profile': (BuildContext context) => const EditProfileScreen(),
  };
}
