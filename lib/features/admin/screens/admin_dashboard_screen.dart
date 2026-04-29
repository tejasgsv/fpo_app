import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/app_card.dart';
import '../../auth/widgets/primary_button.dart';
import '../services/admin_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.adminService});

  final AdminService adminService;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<SystemOverview> _overviewFuture;

  @override
  void initState() {
    super.initState();
    _overviewFuture = widget.adminService.fetchOverview();
  }

  Future<void> _refresh() async {
    setState(() {
      _overviewFuture = widget.adminService.fetchOverview();
    });
    await _overviewFuture;
  }

  Future<void> _open(String routeName) async {
    await Navigator.of(context).pushNamed(routeName);
    if (mounted) {
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Control Center'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: FutureBuilder<SystemOverview>(
                future: _overviewFuture,
                builder: (context, snapshot) {
                  final overview = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(24),
                        backgroundColor: AppColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Dashboard',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Super Control Center for approvals, activation, moderation, communication, and reporting.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.sectionSpacing),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 1100
                              ? 5
                              : constraints.maxWidth >= 700
                                  ? 3
                                  : 2;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.55,
                            children: [
                              _MetricCard(title: 'Total FPO', value: '${overview?.totalFpo ?? '...'}', icon: Icons.apartment_outlined),
                              _MetricCard(title: 'Pending Approvals', value: '${overview?.pendingApprovals ?? '...'}', icon: Icons.hourglass_bottom_outlined),
                              _MetricCard(title: 'Active Users', value: '${overview?.activeUsers ?? '...'}', icon: Icons.people_outline),
                              _MetricCard(title: 'Total Listings', value: '${overview?.totalListings ?? '...'}', icon: Icons.storefront_outlined),
                              _MetricCard(title: 'Total Requests', value: '${overview?.totalRequests ?? '...'}', icon: Icons.inbox_outlined),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.sectionSpacing),
                      Text('Control Modules', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth = constraints.maxWidth >= 1100
                              ? (constraints.maxWidth - 36) / 4
                              : constraints.maxWidth >= 700
                                  ? (constraints.maxWidth - 12) / 2
                                  : constraints.maxWidth;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.apartment_outlined,
                                title: 'FPO Control',
                                subtitle: 'Review registrations, approve, reject, activate, or suspend.',
                                onTap: () => _open(AppRoutes.adminFpoManagement),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.groups_outlined,
                                title: 'Farmer Data',
                                subtitle: 'View farmer records and filter by FPO ownership.',
                                onTap: () => _open(AppRoutes.adminFarmerData),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.badge_outlined,
                                title: 'Contributors',
                                subtitle: 'Monitor role assignments and permissions.',
                                onTap: () => _open(AppRoutes.adminContributorControl),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.storefront_outlined,
                                title: 'Marketplace',
                                subtitle: 'Block or remove inappropriate product listings.',
                                onTap: () => _open(AppRoutes.adminMarketplaceControl),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.chat_bubble_outline,
                                title: 'Communication',
                                subtitle: 'Monitor conversations and report activity.',
                                onTap: () => _open(AppRoutes.adminChatMonitoring),
                              ),
                              _ModuleCard(
                                width: cardWidth,
                                icon: Icons.bar_chart_outlined,
                                title: 'Analytics',
                                subtitle: 'Review growth, usage, and system trends.',
                                onTap: () => _open(AppRoutes.adminAnalytics),
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
                            Text('Platform Flow', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text('Registration -> Review -> Approval -> Activation -> Dashboard -> Operations'),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton(
                                  onPressed: () => _open(AppRoutes.adminFpoManagement),
                                  child: const Text('Open FPO Queue'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _open(AppRoutes.adminMarketplaceControl),
                                  child: const Text('Open Marketplace'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _open(AppRoutes.adminChatMonitoring),
                                  child: const Text('Open Chat Monitor'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
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
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
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
