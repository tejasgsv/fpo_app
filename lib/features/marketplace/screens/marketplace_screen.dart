import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_routes.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/marketplace/models/product_listing.dart';
import 'package:fpo_app/features/marketplace/services/marketplace_service.dart';
import 'package:fpo_app/features/chat/models/chat_models.dart';
import 'package:fpo_app/features/chat/services/chat_service.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({
    super.key,
    required this.marketplaceService,
    required this.chatService,
  });

  final MarketplaceService marketplaceService;
  final ChatService chatService;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late Future<List<ProductListing>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    _listingsFuture = widget.marketplaceService.fetchListings();
  }

  Future<void> _refreshListings() async {
    setState(() {
      _listingsFuture = widget.marketplaceService.fetchListings();
    });
    await _listingsFuture;
  }

  Future<void> _openChat(ProductListing listing) async {
    final thread = await widget.chatService.startConversation(
      partnerName: listing.fpoName,
      contextLabel: listing.cropName,
    );

    if (!mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(
      AppRoutes.conversation,
      arguments: ChatConversationArgs(
        threadId: thread.id,
        partnerName: thread.partnerName,
        contextLabel: thread.contextLabel,
      ),
    );
    await _refreshListings();
  }

  Future<void> _sendRequest(ProductListing listing) async {
    await widget.marketplaceService.sendRequest(
      productId: listing.id,
      message: 'Request sent for ${listing.cropName}. Please share availability and logistics details.',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent')),
      );
      await _refreshListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.marketplaceTitle),
        actions: [
          IconButton(
            onPressed: () async {
              final added = await Navigator.of(context).pushNamed(
                AppRoutes.addProduct,
                arguments: 'FPO Network',
              );
              if (added == true) {
                await _refreshListings();
              }
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: AppStrings.addProductTitle,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshListings,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
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
                    return AppCard(child: Text(AppStrings.noListingsYet));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.marketplaceTitle, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text(AppStrings.marketplaceIntro),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
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
                                      child: const Icon(Icons.agriculture_outlined, color: Colors.green),
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
                                    Chip(label: Text(listing.quality)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _ListingInfo(label: AppStrings.quantityLabel, value: listing.quantity),
                                _ListingInfo(label: AppStrings.availableDateLabel, value: _formatDate(listing.availableDate)),
                                const SizedBox(height: 8),
                                Text(listing.description),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilledButton(
                                      onPressed: () => _openChat(listing),
                                      child: const Text(AppStrings.contactFpo),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => _sendRequest(listing),
                                      child: const Text(AppStrings.sendRequest),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => _openChat(listing),
                                      child: const Text(AppStrings.chat),
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

String _formatDate(DateTime dateTime) {
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  return '$day/$month/${dateTime.year}';
}

class _ListingInfo extends StatelessWidget {
  const _ListingInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}