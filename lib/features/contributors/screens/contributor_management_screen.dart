import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/auth/widgets/primary_button.dart';
import 'package:fpo_app/features/contributors/models/contributor.dart';
import 'package:fpo_app/features/contributors/services/contributor_service.dart';

class ContributorManagementScreen extends StatefulWidget {
  const ContributorManagementScreen({super.key, required this.contributorService});

  final ContributorService contributorService;

  @override
  State<ContributorManagementScreen> createState() => _ContributorManagementScreenState();
}

class _ContributorManagementScreenState extends State<ContributorManagementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  String _selectedRole = 'Manager';
  bool _addProduct = true;
  bool _viewData = true;
  bool _manageRequests = true;
  late Future<List<Contributor>> _contributorsFuture;

  @override
  void initState() {
    super.initState();
    _contributorsFuture = widget.contributorService.fetchContributors();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _refreshContributors() async {
    setState(() {
      _contributorsFuture = widget.contributorService.fetchContributors();
    });
    await _contributorsFuture;
  }

  Future<void> _addContributor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.contributorService.addContributor(
      ContributorDraft(
        name: _nameController.text.trim(),
        role: _selectedRole,
        permissions: ContributorPermissions(
          addProduct: _addProduct,
          viewData: _viewData,
          manageRequests: _manageRequests,
        ),
      ),
    );

    _nameController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contributor added')),
      );
      await _refreshContributors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contributorManagementTitle)),
      body: RefreshIndicator(
        onRefresh: _refreshContributors,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.addContributor, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: AppStrings.contributorNameLabel),
                            validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedRole,
                            decoration: const InputDecoration(labelText: AppStrings.roleLabel),
                            items: const [
                              DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                              DropdownMenuItem(value: 'Data Entry', child: Text('Data Entry')),
                              DropdownMenuItem(value: 'Viewer', child: Text('Viewer')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value ?? 'Manager';
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            value: _addProduct,
                            onChanged: (value) => setState(() => _addProduct = value),
                            title: const Text(AppStrings.permissionAddProduct),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            value: _viewData,
                            onChanged: (value) => setState(() => _viewData = value),
                            title: const Text(AppStrings.permissionViewData),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            value: _manageRequests,
                            onChanged: (value) => setState(() => _manageRequests = value),
                            title: const Text(AppStrings.permissionManageRequests),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(label: AppStrings.saveContributor, onPressed: _addContributor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(AppStrings.contributorListTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Contributor>>(
                    future: _contributorsFuture,
                    builder: (context, snapshot) {
                      final contributors = snapshot.data ?? const <Contributor>[];
                      if (snapshot.connectionState == ConnectionState.waiting && contributors.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (contributors.isEmpty) {
                        return AppCard(child: Text(AppStrings.noContributorsYet));
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contributors.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final contributor = contributors[index];
                          return AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                      child: Text(contributor.name.isNotEmpty ? contributor.name[0].toUpperCase() : '?'),
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
                                    _PermissionChip(label: AppStrings.permissionAddProduct, enabled: contributor.permissions.addProduct),
                                    _PermissionChip(label: AppStrings.permissionViewData, enabled: contributor.permissions.viewData),
                                    _PermissionChip(label: AppStrings.permissionManageRequests, enabled: contributor.permissions.manageRequests),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: enabled ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : null,
      side: BorderSide(color: enabled ? Theme.of(context).colorScheme.primary : const Color(0xFFE0E0E0)),
    );
  }
}