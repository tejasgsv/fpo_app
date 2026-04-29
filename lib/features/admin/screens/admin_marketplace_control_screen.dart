import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/platform_store.dart';
import '../../auth/widgets/app_card.dart';
import '../services/admin_service.dart';

class AdminMarketplaceControlScreen extends StatefulWidget {
  const AdminMarketplaceControlScreen({super.key, required this.adminService});

  final AdminService adminService;

  @override
  State<AdminMarketplaceControlScreen> createState() => _AdminMarketplaceControlScreenState();
}

class _AdminMarketplaceControlScreenState extends State<AdminMarketplaceControlScreen> {
  late Future<List<ProductListing>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = widget.adminService.fetchListings();
  }

  Future<void> _refresh() async {
    setState(() {
      _listingsFuture = widget.adminService.fetchListings();
    });
    await _listingsFuture;
  }

  Future<void> _moderate(Future<void> Function() action, String message) async {
    await action();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Control')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: FutureBuilder<List<ProductListing>>(
                future: _listingsFuture,
                builder: (context, snapshot) {
                  final listings = snapshot.data ?? const <ProductListing>[];
                  if (snapshot.connectionState == ConnectionState.waiting && listings.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (listings.isEmpty) {
                    return const AppCard(child: Text('No marketplace listings found.'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Marketplace Moderation', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text('Block or remove listings that do not meet platform rules.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final listing = listings[index];
                          return AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                      child: const Icon(Icons.storefront_outlined, color: Colors.green),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(listing.cropName, style: Theme.of(context).textTheme.titleMedium),
                                          const SizedBox(height: 4),
                                          Text('${listing.fpoName} • ${listing.location}'),
                                        ],
                                      ),
                                    ),
                                    Chip(label: Text(listing.status.name)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _row('Quantity', listing.quantity),
                                _row('Quality', listing.quality),
                                _row('Available', _formatDate(listing.availableDate)),
                                const SizedBox(height: 12),
                                Text(listing.description),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    OutlinedButton(
                                      onPressed: listing.status == ListingStatus.live
                                          ? () => _moderate(() => widget.adminService.blockListing(listing.id), 'Listing blocked')
                                          : null,
                                      child: const Text('Block'),
                                    ),
                                    OutlinedButton(
                                      onPressed: listing.status != ListingStatus.removed
                                          ? () => _moderate(() => widget.adminService.removeListing(listing.id), 'Listing removed')
                                          : null,
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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

Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

String _formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}
