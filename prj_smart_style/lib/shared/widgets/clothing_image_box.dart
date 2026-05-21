import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_colors.dart';
import 'package:prj_smart_style/app/theme/app_radius.dart';

class ClothingImageBox extends StatelessWidget {
  final String imagePath;
  final bool isImageAvailable;

  final VoidCallback? onTap;

  const ClothingImageBox({
    super.key,
    required this.imagePath,
    this.isImageAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;

        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: isImageAvailable
                  ? Image.file(File(imagePath), fit: BoxFit.cover)
                  : Icon(Icons.broken_image_outlined, size: size * 0.4),
            ),
          ),
        );
      },
    );
  }
}
