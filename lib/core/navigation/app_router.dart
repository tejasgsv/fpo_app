import 'package:flutter/material.dart';

import '../../features/auth/screens/dashboard_screen.dart';
import '../../features/auth/screens/fpo_registration_flow_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/success_screen.dart';
import '../constants/app_routes.dart';
import '../di/app_services.dart';

class AppRouter {
  static final AppServices _services = AppServices();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? AppRoutes.login);

    switch (uri.path) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            authService: _services.authService,
          ),
          settings: settings,
        );
      case AppRoutes.registerFpo:
      case AppRoutes.registerFpoStep1:
        return MaterialPageRoute(
          builder: (_) => FpoRegistrationFlowScreen(
            registrationService: _services.registrationService,
            initialStep: 0,
          ),
          settings: settings,
        );
      case AppRoutes.registerFpoStep2:
        return MaterialPageRoute(
          builder: (_) => FpoRegistrationFlowScreen(
            registrationService: _services.registrationService,
            initialStep: 1,
          ),
          settings: settings,
        );
      case AppRoutes.registerFpoStep3:
        return MaterialPageRoute(
          builder: (_) => FpoRegistrationFlowScreen(
            registrationService: _services.registrationService,
            initialStep: 2,
          ),
          settings: settings,
        );
      case AppRoutes.registerFpoStep4:
        return MaterialPageRoute(
          builder: (_) => FpoRegistrationFlowScreen(
            registrationService: _services.registrationService,
            initialStep: 3,
          ),
          settings: settings,
        );
      case AppRoutes.success:
        return MaterialPageRoute(
          builder: (_) => const SuccessScreen(),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(
            authService: _services.authService,
          ),
          settings: const RouteSettings(name: AppRoutes.login),
        );
    }
  }
}
