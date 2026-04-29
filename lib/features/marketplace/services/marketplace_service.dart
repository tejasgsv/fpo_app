import '../../../core/state/platform_store.dart';
import '../models/product_listing.dart';

abstract class MarketplaceService {
  Future<List<ProductListing>> fetchListings();

  Future<ProductListing> addListing(ProductDraft draft);

  Future<void> sendRequest({required String productId, required String message});

  Future<int> fetchIncomingRequestCount();

  Future<void> removeListing(String listingId);

  Future<void> blockListing(String listingId);
}

class MockMarketplaceService implements MarketplaceService {
  MockMarketplaceService({required this.platformStore});

  final PlatformStore platformStore;
  final List<MarketplaceRequest> _requests = [];

  @override
  Future<ProductListing> addListing(ProductDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final listing = platformStore.upsertListing(
      cropName: draft.cropName,
      quantity: draft.quantity,
      quality: draft.quality,
      location: draft.location,
      fpoName: draft.fpoName,
      availableDate: draft.availableDate,
      description: draft.description,
    );
    return listing;
  }

  @override
  Future<int> fetchIncomingRequestCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _requests.length;
  }

  @override
  Future<List<ProductListing>> fetchListings() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return platformStore.fetchListings();
  }

  @override
  Future<void> sendRequest({required String productId, required String message}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _requests.insert(
      0,
      MarketplaceRequest(
        id: 'request_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> removeListing(String listingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    platformStore.updateListingStatus(listingId, ListingStatus.removed);
  }

  @override
  Future<void> blockListing(String listingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    platformStore.updateListingStatus(listingId, ListingStatus.blocked);
  }
}