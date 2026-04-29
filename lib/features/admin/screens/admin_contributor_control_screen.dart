import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/widgets/app_card.dart';
import '../../contributors/models/contributor.dart';
import '../../contributors/services/contributor_service.dart';

class AdminContributorControlScreen extends StatefulWidget {
  const AdminContributorControlScreen({super.key, required this.contributorService});

  final ContributorService contributorService;

  @override
  State<AdminContributorControlScreen> createState() => _AdminContributorControlScreenState();
}

class _AdminContributorControlScreenState extends State<AdminContributorControlScreen> {
  late Future<List<Contributor>> _contributorsFuture;
  String _roleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _contributorsFuture = widget.contributorService.fetchContributors();
  }

  Future<void> _refresh() async {
    setState(() {
      _contributorsFuture = widget.contributorService.fetchContributors();
    });
    await _contributorsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contributor Control')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: FutureBuilder<List<Contributor>>(
                future: _contributorsFuture,
                builder: (context, snapshot) {
                  final contributors = snapshot.data ?? const <Contributor>[];
                  final roles = <String>{'All', ...contributors.map((contributor) => contributor.role)}.toList();
                  final filtered = _roleFilter == 'All'
                      ? contributors
                      : contributors.where((contributor) => contributor.role == _roleFilter).toList(growable: false);

                  if (snapshot.connectionState == ConnectionState.waiting && contributors.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contributor Monitoring', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text('Inspect roles, permissions, and contributor activity across FPO teams.'),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: roles
                                  .map(
                                    (role) => ChoiceChip(
                                      label: Text(role),
                                      selected: _roleFilter == role,
                                      onSelected: (_) {
                                        setState(() {
                                          _roleFilter = role;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (filtered.isEmpty)
                        const AppCard(child: Text('No contributors found.'))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final contributor = filtered[index];
                            return AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                        child: Text(contributor.name[0].toUpperCase()),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(contributor.name, style: Theme.of(context).textTheme.titleMedium),
                                            const SizedBox(height: 4),
                                            Text('${contributor.role} • ${contributor.status}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _permChip('Add Product', contributor.permissions.addProduct),
                                      _permChip('View Data', contributor.permissions.viewData),
                                      _permChip('Manage Requests', contributor.permissions.manageRequests),
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

Widget _permChip(String label, bool enabled) {
  return Chip(
    label: Text(label),
    backgroundColor: enabled ? Colors.green.withValues(alpha: 0.12) : null,
    side: BorderSide(color: enabled ? Colors.green : const Color(0xFFE0E0E0)),
  );
}
