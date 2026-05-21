import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';
import 'package:prj_smart_style/features/auth/presentation/controllers/auth_controller.dart';
import 'package:prj_smart_style/features/auth/presentation/widgets/auth_card.dart';
import 'package:prj_smart_style/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:prj_smart_style/shared/widgets/primary_button.dart';
import 'package:prj_smart_style/shared/widgets/special_background.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool acceptedTerms = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final authController = context.read<AuthController>();

    final success = await authController.register(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      acceptedTerms: acceptedTerms,
    );

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SpecialBackground(
        child: AuthCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text("Create Your Account", style: AppTextStyles.title),
              ),

              const SizedBox(height: AppSpacing.lg),

              AuthInputField(
                controller: nameController,
                hintText: "Name",
                icon: Icons.person_outline,
                onChanged: (_) {
                  authController.clearError();
                },
              ),

              const SizedBox(height: AppSpacing.md),

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
                hintText: "Enter New Password",
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

              const SizedBox(height: AppSpacing.md),

              AuthInputField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                icon: Icons.lock_outline,
                isPassword: !isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isConfirmPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: AppSpacing.md,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                ),
                onChanged: (_) {
                  authController.clearError();
                },
              ),

              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: AppSpacing.xl,
                child: authController.errorMessage != null
                    ? Text(
                        authController.errorMessage!,

                        style: AppTextStyles.small.copyWith(color: Colors.red),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: AppSpacing.sm),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppSpacing.md,
                    height: AppSpacing.md,
                    child: Checkbox(
                      value: acceptedTerms,
                      onChanged: authController.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                acceptedTerms = value ?? false;
                              });

                              authController.clearError();
                            },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: AppTextStyles.small,
                        children: [
                          TextSpan(text: "I agree to the "),
                          TextSpan(
                            text: "Terms Of Use & Privacy\nPolicy",
                            style: AppTextStyles.link,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              PrimaryButton(
                text: authController.isLoading ? "Loading..." : "Sign Up",
                onPressed: authController.isLoading ? null : _handleRegister,
              ),

              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an Account? - ",
                    style: AppTextStyles.body,
                  ),
                  GestureDetector(
                    onTap: authController.isLoading
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                    child: const Text("Login", style: AppTextStyles.link),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
