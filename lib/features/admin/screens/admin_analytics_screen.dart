import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/widgets/app_card.dart';
import '../services/admin_service.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key, required this.adminService});

  final AdminService adminService;

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & Reports')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: FutureBuilder<SystemOverview>(
                future: _overviewFuture,
                builder: (context, snapshot) {
                  final overview = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('System Analytics', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text('Dense operational metrics for platform review and growth tracking.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 900 ? 4 : 2;
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.45,
                            children: [
                              _MetricCard(label: 'Active FPOs', value: '${overview?.activeFpos ?? '...'}', color: AppColors.primary),
                              _MetricCard(label: 'Pending Approvals', value: '${overview?.pendingApprovals ?? '...'}', color: Colors.orange),
                              _MetricCard(label: 'Blocked Listings', value: '${overview?.blockedListings ?? '...'}', color: Colors.red),
                              _MetricCard(label: 'Active Users', value: '${overview?.activeUsers ?? '...'}', color: AppColors.secondary),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Growth Snapshot', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            _BarMetric(label: 'FPO', value: overview?.totalFpo ?? 0, color: AppColors.primary),
                            _BarMetric(label: 'Listings', value: overview?.totalListings ?? 0, color: AppColors.secondary),
                            _BarMetric(label: 'Requests', value: overview?.totalRequests ?? 0, color: Colors.teal),
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
  const _MetricCard({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 8, width: 48, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 16),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _BarMetric extends StatelessWidget {
  const _BarMetric({required this.label, required this.value, required this.color});

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final capped = value.clamp(1, 100);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 82, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: capped / 100,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 40, child: Text('$value', textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
