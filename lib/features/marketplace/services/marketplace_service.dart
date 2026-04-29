import '../models/product_listing.dart';

abstract class MarketplaceService {
  Future<List<ProductListing>> fetchListings();

  Future<ProductListing> addListing(ProductDraft draft);

  Future<void> sendRequest({required String productId, required String message});

  Future<int> fetchIncomingRequestCount();
}

class MockMarketplaceService implements MarketplaceService {
  MockMarketplaceService()
      : _listings = [
          ProductListing(
            id: 'listing_1',
            cropName: 'Organic Wheat',
            quantity: '45 quintals',
            quality: 'Grade A',
            location: 'Maharashtra - Pune',
            fpoName: 'Sahyadri FPO',
            availableDate: DateTime.now().add(const Duration(days: 4)),
            description: 'Cleaned and bagged wheat ready for institutional supply.',
          ),
          ProductListing(
            id: 'listing_2',
            cropName: 'Fresh Tomato',
            quantity: '18 tonnes',
            quality: 'Premium',
            location: 'Gujarat - Surat',
            fpoName: 'Krushi Mitra FPO',
            availableDate: DateTime.now().add(const Duration(days: 2)),
            description: 'Harvested this week and suitable for bulk logistics.',
          ),
          ProductListing(
            id: 'listing_3',
            cropName: 'Turmeric Finger',
            quantity: '12 quintals',
            quality: 'A Grade',
            location: 'Tamil Nadu - Madurai',
            fpoName: 'Delta Farmers FPO',
            availableDate: DateTime.now().add(const Duration(days: 8)),
            description: 'Well dried turmeric with uniform finger size and color.',
          ),
        ];

  final List<ProductListing> _listings;
  final List<MarketplaceRequest> _requests = [];

  @override
  Future<ProductListing> addListing(ProductDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final listing = ProductListing(
      id: 'listing_${DateTime.now().millisecondsSinceEpoch}',
      cropName: draft.cropName,
      quantity: draft.quantity,
      quality: draft.quality,
      location: draft.location,
      fpoName: draft.fpoName,
      availableDate: draft.availableDate,
      description: draft.description,
    );
    _listings.insert(0, listing);
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
    return List<ProductListing>.unmodifiable(_listings);
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
}