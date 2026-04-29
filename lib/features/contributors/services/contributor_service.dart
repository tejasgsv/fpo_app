import '../models/contributor.dart';

abstract class ContributorService {
  Future<List<Contributor>> fetchContributors();

  Future<Contributor> addContributor(ContributorDraft draft);
}

class MockContributorService implements ContributorService {
  MockContributorService()
      : _contributors = [
          const Contributor(
            id: 'contributor_1',
            name: 'Neha Sharma',
            role: 'Manager',
            permissions: ContributorPermissions(
              addProduct: true,
              viewData: true,
              manageRequests: true,
            ),
            status: 'Active',
          ),
          const Contributor(
            id: 'contributor_2',
            name: 'Imran Khan',
            role: 'Data Entry',
            permissions: ContributorPermissions(
              addProduct: true,
              viewData: true,
              manageRequests: false,
            ),
            status: 'Active',
          ),
          const Contributor(
            id: 'contributor_3',
            name: 'Priya Nair',
            role: 'Viewer',
            permissions: ContributorPermissions(
              addProduct: false,
              viewData: true,
              manageRequests: false,
            ),
            status: 'Invited',
          ),
        ];

  final List<Contributor> _contributors;

  @override
  Future<Contributor> addContributor(ContributorDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final contributor = Contributor(
      id: 'contributor_${DateTime.now().millisecondsSinceEpoch}',
      name: draft.name,
      role: draft.role,
      permissions: draft.permissions,
      status: 'Active',
    );
    _contributors.insert(0, contributor);
    return contributor;
  }

  @override
  Future<List<Contributor>> fetchContributors() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List<Contributor>.unmodifiable(_contributors);
  }
}