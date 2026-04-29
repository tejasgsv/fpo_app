import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_routes.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/core/theme/app_colors.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/contributors/services/contributor_service.dart';
import 'package:fpo_app/features/fpo_dashboard/services/farmer_service.dart';
import 'package:fpo_app/features/marketplace/services/marketplace_service.dart';
import 'package:fpo_app/features/chat/services/chat_service.dart';

class FpoDashboardScreen extends StatefulWidget {
  const FpoDashboardScreen({
    super.key,
    required this.farmerService,
    required this.contributorService,
    required this.marketplaceService,
    required this.chatService,
  });

  final FarmerService farmerService;
  final ContributorService contributorService;
  final MarketplaceService marketplaceService;
  final ChatService chatService;

  @override
  State<FpoDashboardScreen> createState() => _FpoDashboardScreenState();
}

class _FpoDashboardScreenState extends State<FpoDashboardScreen> {
  late Future<_DashboardSummary> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _loadSummary();
  }

  Future<_DashboardSummary> _loadSummary() async {
    final farmers = await widget.farmerService.fetchFarmers();
    final contributors = await widget.contributorService.fetchContributors();
    final listings = await widget.marketplaceService.fetchListings();
    final incomingRequests = await widget.marketplaceService.fetchIncomingRequestCount();

    return _DashboardSummary(
      totalFarmers: farmers.length,
      activeMembers: contributors.length,
      activeListings: listings.length,
      incomingRequests: incomingRequests,
    );
  }

  Future<void> _openRoute(String routeName) async {
    await Navigator.of(context).pushNamed(routeName);
    if (mounted) {
      setState(() {
        _summaryFuture = _loadSummary();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dashboardTitle)),
      body: FutureBuilder<_DashboardSummary>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          final summary = snapshot.data;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _summaryFuture = _loadSummary();
              });
              await _summaryFuture;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(24),
                        backgroundColor: AppColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.dashboardTitle,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.dashboardSubtitle,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.sectionSpacing),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 900
                              ? 4
                              : constraints.maxWidth >= 600
                                  ? 2
                                  : 1;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.6,
                            children: [
                              _StatCard(title: AppStrings.totalFarmers, value: '${summary?.totalFarmers ?? '...'}', icon: Icons.groups_outlined),
                              _StatCard(title: AppStrings.activeMembers, value: '${summary?.activeMembers ?? '...'}', icon: Icons.verified_user_outlined),
                              _StatCard(title: AppStrings.activeListings, value: '${summary?.activeListings ?? '...'}', icon: Icons.storefront_outlined),
                              _StatCard(title: AppStrings.incomingRequests, value: '${summary?.incomingRequests ?? '...'}', icon: Icons.inbox_outlined),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.sectionSpacing),
                      Text(AppStrings.mainModules, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth = constraints.maxWidth >= 900
                              ? (constraints.maxWidth - 24) / 3
                              : constraints.maxWidth >= 600
                                  ? (constraints.maxWidth - 12) / 2
                                  : constraints.maxWidth;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.groups_2_outlined,
                                title: AppStrings.farmerManagementTitle,
                                subtitle: AppStrings.farmerManagementSubtitle,
                                onTap: () => _openRoute(AppRoutes.farmers),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.badge_outlined,
                                title: AppStrings.contributorManagementTitle,
                                subtitle: AppStrings.contributorManagementSubtitle,
                                onTap: () => _openRoute(AppRoutes.contributors),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.storefront_outlined,
                                title: AppStrings.marketplaceTitle,
                                subtitle: AppStrings.marketplaceSubtitle,
                                onTap: () => _openRoute(AppRoutes.marketplace),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.chat_bubble_outline,
                                title: AppStrings.communicationTitle,
                                subtitle: AppStrings.communicationSubtitle,
                                onTap: () => _openRoute(AppRoutes.chats),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.inventory_2_outlined,
                                title: AppStrings.inventoryTitle,
                                subtitle: AppStrings.inventorySubtitle,
                                onTap: () => _openRoute(AppRoutes.inventory),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.bar_chart_outlined,
                                title: AppStrings.reportsTitle,
                                subtitle: AppStrings.reportsSubtitle,
                                onTap: () => _openRoute(AppRoutes.reports),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.sectionSpacing),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.dashboardFlowTitle, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text(AppStrings.dashboardFlowBody),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _PillAction(label: AppStrings.farmerManagementTitle, onTap: () => _openRoute(AppRoutes.farmers)),
                                _PillAction(label: AppStrings.marketplaceTitle, onTap: () => _openRoute(AppRoutes.marketplace)),
                                _PillAction(label: AppStrings.communicationTitle, onTap: () => _openRoute(AppRoutes.chats)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardSummary {
  const _DashboardSummary({
    required this.totalFarmers,
    required this.activeMembers,
    required this.activeListings,
    required this.incomingRequests,
  });

  final int totalFarmers;
  final int activeMembers;
  final int activeListings;
  final int incomingRequests;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.14),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.14),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillAction extends StatelessWidget {
  const _PillAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}