import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';

class UserInitialAvatar extends StatelessWidget {
  final String fullName;
  final double radius;

  const UserInitialAvatar({
    super.key,
    required this.fullName,
    this.radius = 28,
  });

  String get _initial {
    final trimmedName = fullName.trim();

    if (trimmedName.isEmpty) {
      return "?";
    }

    return trimmedName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.gradientTop,
      child: Text(
        _initial,
        style: AppTextStyles.avatarName.copyWith(color: AppColors.lightText),
      ),
    );
  }
}
