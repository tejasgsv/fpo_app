import '../../features/marketplace/models/product_listing.dart';

enum PlatformRole {
  admin,
  fpo,
}

enum FpoApplicationStatus {
  pending,
  approved,
  active,
  suspended,
  rejected,
  correctionRequired,
}

class FpoApplication {
  const FpoApplication({
    required this.id,
    required this.fpoName,
    required this.registrationNumber,
    required this.state,
    required this.district,
    required this.address,
    required this.mobileNumber,
    required this.certificateName,
    required this.additionalDocumentName,
    required this.status,
    required this.submittedAt,
    required this.updatedAt,
    this.reviewNote,
    this.activatedAt,
  });

  final String id;
  final String fpoName;
  final String registrationNumber;
  final String state;
  final String district;
  final String address;
  final String mobileNumber;
  final String certificateName;
  final String? additionalDocumentName;
  final FpoApplicationStatus status;
  final DateTime submittedAt;
  final DateTime updatedAt;
  final String? reviewNote;
  final DateTime? activatedAt;

  FpoApplication copyWith({
    String? id,
    String? fpoName,
    String? registrationNumber,
    String? state,
    String? district,
    String? address,
    String? mobileNumber,
    String? certificateName,
    String? additionalDocumentName,
    FpoApplicationStatus? status,
    DateTime? submittedAt,
    DateTime? updatedAt,
    String? reviewNote,
    DateTime? activatedAt,
  }) {
    return FpoApplication(
      id: id ?? this.id,
      fpoName: fpoName ?? this.fpoName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      state: state ?? this.state,
      district: district ?? this.district,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      certificateName: certificateName ?? this.certificateName,
      additionalDocumentName: additionalDocumentName ?? this.additionalDocumentName,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reviewNote: reviewNote ?? this.reviewNote,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }
}

class PlatformStore {
  PlatformStore()
      : _applications = [
          FpoApplication(
            id: 'fpo_app_1',
            fpoName: 'Sahyadri FPO',
            registrationNumber: 'FPO-2026-001',
            state: 'Maharashtra',
            district: 'Pune',
            address: 'Pune District, Maharashtra',
            mobileNumber: '9876543210',
            certificateName: 'Sahyadri_Certificate.pdf',
            additionalDocumentName: 'Audit_Report.pdf',
            status: FpoApplicationStatus.active,
            submittedAt: DateTime.now().subtract(const Duration(days: 18)),
            updatedAt: DateTime.now().subtract(const Duration(days: 2)),
            activatedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          FpoApplication(
            id: 'fpo_app_2',
            fpoName: 'Krushi Mitra FPO',
            registrationNumber: 'FPO-2026-002',
            state: 'Gujarat',
            district: 'Surat',
            address: 'Surat District, Gujarat',
            mobileNumber: '9898989898',
            certificateName: 'KrushiMitra_Certificate.pdf',
            additionalDocumentName: null,
            status: FpoApplicationStatus.approved,
            submittedAt: DateTime.now().subtract(const Duration(days: 11)),
            updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          FpoApplication(
            id: 'fpo_app_3',
            fpoName: 'Delta Farmers FPO',
            registrationNumber: 'FPO-2026-003',
            state: 'Tamil Nadu',
            district: 'Madurai',
            address: 'Madurai District, Tamil Nadu',
            mobileNumber: '9777712345',
            certificateName: 'Delta_Certificate.pdf',
            additionalDocumentName: null,
            status: FpoApplicationStatus.pending,
            submittedAt: DateTime.now().subtract(const Duration(days: 4)),
            updatedAt: DateTime.now().subtract(const Duration(days: 4)),
          ),
          FpoApplication(
            id: 'fpo_app_4',
            fpoName: 'Green Valley FPO',
            registrationNumber: 'FPO-2026-004',
            state: 'Punjab',
            district: 'Ludhiana',
            address: 'Ludhiana District, Punjab',
            mobileNumber: '9666612345',
            certificateName: 'GreenValley_Certificate.pdf',
            additionalDocumentName: null,
            status: FpoApplicationStatus.suspended,
            submittedAt: DateTime.now().subtract(const Duration(days: 23)),
            updatedAt: DateTime.now().subtract(const Duration(days: 3)),
            reviewNote: 'Pending compliance verification.',
          ),
        ],
        _listings = [
          ProductListing(
            id: 'listing_1',
            cropName: 'Organic Wheat',
            quantity: '45 quintals',
            quality: 'Grade A',
            location: 'Maharashtra - Pune',
            fpoName: 'Sahyadri FPO',
            availableDate: DateTime.now().add(const Duration(days: 4)),
            description: 'Cleaned and bagged wheat ready for institutional supply.',
            status: ListingStatus.live,
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
            status: ListingStatus.live,
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
            status: ListingStatus.live,
          ),
        ];

  final List<FpoApplication> _applications;
  final List<ProductListing> _listings;

  List<FpoApplication> fetchApplications({FpoApplicationStatus? status}) {
    final applications = status == null
        ? _applications
        : _applications.where((application) => application.status == status).toList(growable: false);
    return List<FpoApplication>.unmodifiable(applications);
  }

  FpoApplication? findApplicationById(String applicationId) {
    for (final application in _applications) {
      if (application.id == applicationId) {
        return application;
      }
    }
    return null;
  }

  FpoApplication? findApplicationByLoginValue(String loginValue) {
    final value = loginValue.trim().toLowerCase();
    for (final application in _applications) {
      final registrationNumber = application.registrationNumber.toLowerCase();
      final fpoName = application.fpoName.toLowerCase();
      final mobileNumber = application.mobileNumber.toLowerCase();
      if (value == registrationNumber || value == fpoName || value == mobileNumber) {
        return application;
      }
    }
    return null;
  }

  FpoApplication upsertApplication({
    required String fpoName,
    required String registrationNumber,
    required String state,
    required String district,
    required String address,
    required String mobileNumber,
    required String certificateName,
    required String? additionalDocumentName,
  }) {
    final existingIndex = _applications.indexWhere(
      (application) => application.registrationNumber.toLowerCase() == registrationNumber.toLowerCase(),
    );

    final application = FpoApplication(
      id: existingIndex == -1 ? 'fpo_app_${DateTime.now().millisecondsSinceEpoch}' : _applications[existingIndex].id,
      fpoName: fpoName,
      registrationNumber: registrationNumber,
      state: state,
      district: district,
      address: address,
      mobileNumber: mobileNumber,
      certificateName: certificateName,
      additionalDocumentName: additionalDocumentName,
      status: FpoApplicationStatus.pending,
      submittedAt: existingIndex == -1 ? DateTime.now() : _applications[existingIndex].submittedAt,
      updatedAt: DateTime.now(),
      reviewNote: null,
      activatedAt: existingIndex == -1 ? null : _applications[existingIndex].activatedAt,
    );

    if (existingIndex == -1) {
      _applications.insert(0, application);
    } else {
      _applications[existingIndex] = application;
    }

    return application;
  }

  FpoApplication updateApplicationStatus(
    String applicationId,
    FpoApplicationStatus status, {
    String? reviewNote,
  }) {
    final index = _applications.indexWhere((application) => application.id == applicationId);
    if (index == -1) {
      throw StateError('Application not found');
    }

    final current = _applications[index];
    final updated = current.copyWith(
      status: status,
      updatedAt: DateTime.now(),
      reviewNote: reviewNote,
      activatedAt: status == FpoApplicationStatus.active ? DateTime.now() : current.activatedAt,
    );
    _applications[index] = updated;
    return updated;
  }

  List<ProductListing> fetchListings({bool includeModerated = false}) {
    final listings = includeModerated
        ? _listings
        : _listings.where((listing) => listing.status == ListingStatus.live).toList(growable: false);
    return List<ProductListing>.unmodifiable(listings);
  }

  ProductListing? findListing(String listingId) {
    for (final listing in _listings) {
      if (listing.id == listingId) {
        return listing;
      }
    }
    return null;
  }

  ProductListing upsertListing({
    required String cropName,
    required String quantity,
    required String quality,
    required String location,
    required String fpoName,
    required DateTime availableDate,
    required String description,
    ListingStatus status = ListingStatus.live,
  }) {
    final listing = ProductListing(
      id: 'listing_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      quantity: quantity,
      quality: quality,
      location: location,
      fpoName: fpoName,
      availableDate: availableDate,
      description: description,
      status: status,
    );
    _listings.insert(0, listing);
    return listing;
  }

  ProductListing updateListingStatus(String listingId, ListingStatus status) {
    final index = _listings.indexWhere((listing) => listing.id == listingId);
    if (index == -1) {
      throw StateError('Listing not found');
    }

    final current = _listings[index];
    final updated = current.copyWith(status: status);
    _listings[index] = updated;
    return updated;
  }

  int countApplications(FpoApplicationStatus status) {
    return _applications.where((application) => application.status == status).length;
  }

  int countActiveFpos() {
    return _applications.where((application) => application.status == FpoApplicationStatus.active).length;
  }

  int countVisibleListings() {
    return _listings.where((listing) => listing.status == ListingStatus.live).length;
  }
}
