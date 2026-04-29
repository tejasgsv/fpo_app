import '../../../core/state/platform_store.dart';
import '../../chat/models/chat_models.dart';
import '../../chat/services/chat_service.dart';
import '../../contributors/services/contributor_service.dart';
import '../../marketplace/models/product_listing.dart';
import '../../marketplace/services/marketplace_service.dart';

class SystemOverview {
  const SystemOverview({
    required this.totalFpo,
    required this.pendingApprovals,
    required this.activeUsers,
    required this.totalListings,
    required this.totalRequests,
    required this.activeFpos,
    required this.blockedListings,
  });

  final int totalFpo;
  final int pendingApprovals;
  final int activeUsers;
  final int totalListings;
  final int totalRequests;
  final int activeFpos;
  final int blockedListings;
}

class AdminService {
  AdminService({
    required this.platformStore,
    required this.marketplaceService,
    required this.chatService,
    required this.contributorService,
  });

  final PlatformStore platformStore;
  final MarketplaceService marketplaceService;
  final ChatService chatService;
  final ContributorService contributorService;

  Future<SystemOverview> fetchOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final applications = platformStore.fetchApplications();
    final contributors = await contributorService.fetchContributors();
    final requests = await marketplaceService.fetchIncomingRequestCount();
    final listings = platformStore.fetchListings(includeModerated: true);

    return SystemOverview(
      totalFpo: applications.length,
      pendingApprovals: platformStore.countApplications(FpoApplicationStatus.pending),
      activeUsers: platformStore.countActiveFpos() + contributors.length,
      totalListings: listings.length,
      totalRequests: requests,
      activeFpos: platformStore.countActiveFpos(),
      blockedListings: listings.where((listing) => listing.status == ListingStatus.blocked).length,
    );
  }

  Future<List<FpoApplication>> fetchApplications({FpoApplicationStatus? status}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return platformStore.fetchApplications(status: status);
  }

  Future<List<FpoApplication>> fetchApprovedApplications() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return platformStore.fetchApplications();
  }

  Future<FpoApplication> approveApplication(String applicationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return platformStore.updateApplicationStatus(applicationId, FpoApplicationStatus.approved);
  }

  Future<FpoApplication> activateApplication(String applicationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return platformStore.updateApplicationStatus(applicationId, FpoApplicationStatus.active);
  }

  Future<FpoApplication> suspendApplication(String applicationId, {String? note}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return platformStore.updateApplicationStatus(applicationId, FpoApplicationStatus.suspended, reviewNote: note);
  }

  Future<FpoApplication> rejectApplication(String applicationId, {String? note}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return platformStore.updateApplicationStatus(applicationId, FpoApplicationStatus.rejected, reviewNote: note);
  }

  Future<FpoApplication> requestCorrection(String applicationId, {String? note}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return platformStore.updateApplicationStatus(applicationId, FpoApplicationStatus.correctionRequired, reviewNote: note);
  }

  Future<List<ProductListing>> fetchListings() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return platformStore.fetchListings(includeModerated: true);
  }

  Future<void> blockListing(String listingId) async {
    await marketplaceService.blockListing(listingId);
  }

  Future<void> removeListing(String listingId) async {
    await marketplaceService.removeListing(listingId);
  }

  Future<List<ChatThread>> fetchThreads() async {
    return chatService.fetchThreads();
  }
}
