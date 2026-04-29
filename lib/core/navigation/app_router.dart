import 'package:flutter/material.dart';

import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/admin_analytics_screen.dart';
import '../../features/admin/screens/admin_contributor_control_screen.dart';
import '../../features/admin/screens/admin_farmer_data_screen.dart';
import '../../features/admin/screens/admin_chat_monitoring_screen.dart';
import '../../features/admin/screens/admin_fpo_management_screen.dart';
import '../../features/admin/screens/admin_marketplace_control_screen.dart';
import '../../features/auth/screens/fpo_registration_flow_screen.dart';
import '../../features/auth/screens/access_status_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/success_screen.dart';
import '../constants/app_routes.dart';
import '../di/app_services.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/chat/models/chat_models.dart';
import '../../features/chat/screens/chat_list_screen.dart';
import '../../features/chat/screens/conversation_screen.dart';
import '../../features/contributors/screens/contributor_management_screen.dart';
import '../../features/fpo_dashboard/screens/dashboard_screen.dart';
import '../../features/fpo_dashboard/screens/farmer_management_screen.dart';
import '../../features/fpo_dashboard/screens/farmer_profile_screen.dart';
import '../../features/fpo_dashboard/screens/module_placeholder_screen.dart';
import '../../features/marketplace/screens/add_product_screen.dart';
import '../../features/marketplace/screens/marketplace_screen.dart';

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
      case AppRoutes.fpoAccessStatus:
        return MaterialPageRoute(
          builder: (_) {
            final session = settings.arguments as AuthSession? ?? AuthSession(
              token: '',
              role: PlatformRole.fpo,
              accountId: '',
              displayName: 'FPO',
              accountStatus: FpoApplicationStatus.pending,
            );
            return AccessStatusScreen(session: session);
          },
          settings: settings,
        );
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(adminService: _services.adminService),
          settings: settings,
        );
      case AppRoutes.adminFarmerData:
        return MaterialPageRoute(
          builder: (_) => AdminFarmerDataScreen(farmerService: _services.farmerService),
          settings: settings,
        );
      case AppRoutes.adminContributorControl:
        return MaterialPageRoute(
          builder: (_) => AdminContributorControlScreen(contributorService: _services.contributorService),
          settings: settings,
        );
      case AppRoutes.adminFpoManagement:
        return MaterialPageRoute(
          builder: (_) => AdminFpoManagementScreen(adminService: _services.adminService),
          settings: settings,
        );
      case AppRoutes.adminMarketplaceControl:
        return MaterialPageRoute(
          builder: (_) => AdminMarketplaceControlScreen(adminService: _services.adminService),
          settings: settings,
        );
      case AppRoutes.adminChatMonitoring:
        return MaterialPageRoute(
          builder: (_) => AdminChatMonitoringScreen(adminService: _services.adminService),
          settings: settings,
        );
      case AppRoutes.adminAnalytics:
        return MaterialPageRoute(
          builder: (_) => AdminAnalyticsScreen(adminService: _services.adminService),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => FpoDashboardScreen(
            farmerService: _services.farmerService,
            contributorService: _services.contributorService,
            marketplaceService: _services.marketplaceService,
            chatService: _services.chatService,
          ),
          settings: settings,
        );
      case AppRoutes.farmers:
        return MaterialPageRoute(
          builder: (_) => FarmerManagementScreen(farmerService: _services.farmerService),
          settings: settings,
        );
      case AppRoutes.farmerProfile:
        return MaterialPageRoute(
          builder: (_) {
            final farmerId = settings.arguments as String? ?? '';
            return FarmerProfileScreen(
              farmerService: _services.farmerService,
              farmerId: farmerId,
            );
          },
          settings: settings,
        );
      case AppRoutes.contributors:
        return MaterialPageRoute(
          builder: (_) => ContributorManagementScreen(contributorService: _services.contributorService),
          settings: settings,
        );
      case AppRoutes.marketplace:
        return MaterialPageRoute(
          builder: (_) => MarketplaceScreen(
            marketplaceService: _services.marketplaceService,
            chatService: _services.chatService,
          ),
          settings: settings,
        );
      case AppRoutes.addProduct:
        return MaterialPageRoute(
          builder: (_) => AddProductScreen(
            marketplaceService: _services.marketplaceService,
            fpoName: (settings.arguments as String?) ?? 'Current FPO',
          ),
          settings: settings,
        );
      case AppRoutes.chats:
        return MaterialPageRoute(
          builder: (_) => ChatListScreen(chatService: _services.chatService),
          settings: settings,
        );
      case AppRoutes.conversation:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as ChatConversationArgs? ?? const ChatConversationArgs(
              threadId: '',
              partnerName: 'Chat',
              contextLabel: 'General',
            );
            return ConversationScreen(
              chatService: _services.chatService,
              args: args,
            );
          },
          settings: settings,
        );
      case AppRoutes.inventory:
        return MaterialPageRoute(
          builder: (_) => const ModulePlaceholderScreen(
            title: 'Inventory',
            message: 'Inventory management will track stock, movement, and storage in a future API-backed release.',
            icon: Icons.inventory_2_outlined,
          ),
          settings: settings,
        );
      case AppRoutes.reports:
        return MaterialPageRoute(
          builder: (_) => const ModulePlaceholderScreen(
            title: 'Reports',
            message: 'Reports will later surface analytics, trends, and performance summaries.',
            icon: Icons.bar_chart_outlined,
          ),
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
