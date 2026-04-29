import '../../features/auth/services/auth_service.dart';
import '../../features/auth/services/registration_service.dart';

class AppServices {
  AppServices()
      : tokenStore = InMemoryTokenStore(),
        registrationService = MockRegistrationService();

  final InMemoryTokenStore tokenStore;
  late final AuthService authService = MockAuthService(tokenStore: tokenStore);
  final RegistrationService registrationService;
}
