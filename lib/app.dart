import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class FpoApp extends StatelessWidget {
  const FpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppRoutes.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
