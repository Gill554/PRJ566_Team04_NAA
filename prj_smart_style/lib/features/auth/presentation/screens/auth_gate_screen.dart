import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authController = context.read<AuthController>();

      await authController.initializeAuthSession();

      if (!mounted) return;

      if (authController.currentUser != null) {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
