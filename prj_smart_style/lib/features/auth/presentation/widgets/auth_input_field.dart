import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const AuthInputField({
    super.key,
    this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          ?suffixIcon,
        ],
      ),
    );
  }
}
