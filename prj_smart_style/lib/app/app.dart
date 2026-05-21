import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/routes/routes.dart';
import 'package:prj_smart_style/app/theme/app_theme.dart';

class SmartStyleApp extends StatelessWidget {
  const SmartStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStyle',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
