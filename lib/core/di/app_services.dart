import '../state/platform_store.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/services/registration_service.dart';
import '../../features/admin/services/admin_service.dart';
import '../../features/chat/services/chat_service.dart';
import '../../features/contributors/services/contributor_service.dart';
import '../../features/fpo_dashboard/services/farmer_service.dart';
import '../../features/marketplace/services/marketplace_service.dart';

class AppServices {
  AppServices()
      : platformStore = PlatformStore(),
      : tokenStore = InMemoryTokenStore(),
        registrationService = MockRegistrationService(platformStore: platformStore),
        farmerService = MockFarmerService(),
        contributorService = MockContributorService(),
        marketplaceService = MockMarketplaceService(platformStore: platformStore),
        chatService = MockChatService(),
        adminService = AdminService(
          platformStore: platformStore,
          marketplaceService: marketplaceService,
          chatService: chatService,
          contributorService: contributorService,
        );

  final PlatformStore platformStore;
  final InMemoryTokenStore tokenStore;
  late final AuthService authService = MockAuthService(tokenStore: tokenStore, platformStore: platformStore);
  final RegistrationService registrationService;
  final AdminService adminService;
  final FarmerService farmerService;
  final ContributorService contributorService;
  final MarketplaceService marketplaceService;
  final ChatService chatService;
}
