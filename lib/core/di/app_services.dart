import '../../features/auth/services/auth_service.dart';
import '../../features/auth/services/registration_service.dart';
import '../../features/chat/services/chat_service.dart';
import '../../features/contributors/services/contributor_service.dart';
import '../../features/fpo_dashboard/services/farmer_service.dart';
import '../../features/marketplace/services/marketplace_service.dart';

class AppServices {
  AppServices()
      : tokenStore = InMemoryTokenStore(),
        registrationService = MockRegistrationService(),
        farmerService = MockFarmerService(),
        contributorService = MockContributorService(),
        marketplaceService = MockMarketplaceService(),
        chatService = MockChatService();

  final InMemoryTokenStore tokenStore;
  late final AuthService authService = MockAuthService(tokenStore: tokenStore);
  final RegistrationService registrationService;
  final FarmerService farmerService;
  final ContributorService contributorService;
  final MarketplaceService marketplaceService;
  final ChatService chatService;
}
