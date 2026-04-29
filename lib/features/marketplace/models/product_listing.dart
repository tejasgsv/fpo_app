enum ListingStatus {
  live,
  blocked,
  removed,
}

class ProductListing {
  const ProductListing({
    required this.id,
    required this.cropName,
    required this.quantity,
    required this.quality,
    required this.location,
    required this.fpoName,
    required this.availableDate,
    required this.description,
    this.status = ListingStatus.live,
  });

  final String id;
  final String cropName;
  final String quantity;
  final String quality;
  final String location;
  final String fpoName;
  final DateTime availableDate;
  final String description;
  final ListingStatus status;

  ProductListing copyWith({
    String? id,
    String? cropName,
    String? quantity,
    String? quality,
    String? location,
    String? fpoName,
    DateTime? availableDate,
    String? description,
    ListingStatus? status,
  }) {
    return ProductListing(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      quantity: quantity ?? this.quantity,
      quality: quality ?? this.quality,
      location: location ?? this.location,
      fpoName: fpoName ?? this.fpoName,
      availableDate: availableDate ?? this.availableDate,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}

class ProductDraft {
  const ProductDraft({
    required this.cropName,
    required this.quantity,
    required this.quality,
    required this.location,
    required this.availableDate,
    required this.description,
    required this.fpoName,
  });

  final String cropName;
  final String quantity;
  final String quality;
  final String location;
  final DateTime availableDate;
  final String description;
  final String fpoName;
}

class MarketplaceRequest {
  const MarketplaceRequest({
    required this.id,
    required this.productId,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String productId;
  final String message;
  final DateTime createdAt;
}