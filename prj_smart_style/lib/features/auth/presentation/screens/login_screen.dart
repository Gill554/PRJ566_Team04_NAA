import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/auth/presentation/widgets/auth_card.dart';
import 'package:prj_smart_style/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/secondary_button.dart';
import 'package:prj_smart_style/shared/widgets/special_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authController = context.read<AuthController>();

    final success = await authController.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      body: SpecialBackground(
        child: AuthCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text("Welcome back", style: AppTextStyles.title),
              ),

              const SizedBox(height: AppSpacing.xl),

              AuthInputField(
                controller: emailController,
                hintText: "Email",
                icon: Icons.mail_outline,
                onChanged: (_) {
                  authController.clearError();
                },
              ),

              const SizedBox(height: AppSpacing.md),

              AuthInputField(
                controller: passwordController,
                hintText: "Enter Password",
                icon: Icons.lock_outline,
                isPassword: !isPasswordVisible,
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: AppSpacing.md,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                onChanged: (_) {
                  authController.clearError();
                },
              ),

              if (authController.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  authController.errorMessage!,
                  style: AppTextStyles.small.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              PrimaryButton(
                text: authController.isLoading ? "Loading..." : "Sign In",
                onPressed: authController.isLoading ? null : _handleLogin,
              ),

              const SizedBox(height: AppSpacing.md),

              SecondaryButton(
                text: "Register",
                onPressed: authController.isLoading
                    ? null
                    : () {
                        Navigator.pushNamed(context, 'registration');
                      },
              ),

              const SizedBox(height: AppSpacing.lg),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Forgot your "),
                  Text("Password?", style: AppTextStyles.link),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
