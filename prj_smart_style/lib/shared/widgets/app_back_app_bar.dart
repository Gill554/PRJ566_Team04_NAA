import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/theme/app_icons.dart';
import 'package:prj_smart_style/app/theme/app_spacing.dart';
import 'package:prj_smart_style/app/theme/app_text_styles.dart';

class AppBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBackAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back_ios_new, size: AppIcons.md),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(title, style: AppTextStyles.appBarTitle),
        ],
      ),
    );
  }
}
