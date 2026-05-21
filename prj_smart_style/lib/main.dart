import 'package:flutter/material.dart';
import 'package:prj_smart_style/app/app.dart';
import 'package:prj_smart_style/app/providers/app_providers.dart';
import 'package:prj_smart_style/shared/firebase/firebase_initializer.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseInitializer.initialize();
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
      child: const SmartStyleApp(),
    ),
  );
}
