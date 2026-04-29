class ContributorPermissions {
  const ContributorPermissions({
    required this.addProduct,
    required this.viewData,
    required this.manageRequests,
  });

  final bool addProduct;
  final bool viewData;
  final bool manageRequests;

  ContributorPermissions copyWith({
    bool? addProduct,
    bool? viewData,
    bool? manageRequests,
  }) {
    return ContributorPermissions(
      addProduct: addProduct ?? this.addProduct,
      viewData: viewData ?? this.viewData,
      manageRequests: manageRequests ?? this.manageRequests,
    );
  }
}

class Contributor {
  const Contributor({
    required this.id,
    required this.name,
    required this.role,
    required this.permissions,
    required this.status,
  });

  final String id;
  final String name;
  final String role;
  final ContributorPermissions permissions;
  final String status;
}

class ContributorDraft {
  const ContributorDraft({
    required this.name,
    required this.role,
    required this.permissions,
  });

  final String name;
  final String role;
  final ContributorPermissions permissions;
}