import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/platform_store.dart';
import '../../auth/widgets/app_card.dart';
import '../services/admin_service.dart';

enum _FpoFilter {
  all,
  pending,
  approved,
  active,
  suspended,
  rejected,
  correctionRequired,
}

class AdminFpoManagementScreen extends StatefulWidget {
  const AdminFpoManagementScreen({super.key, required this.adminService});

  final AdminService adminService;

  @override
  State<AdminFpoManagementScreen> createState() => _AdminFpoManagementScreenState();
}

class _AdminFpoManagementScreenState extends State<AdminFpoManagementScreen> {
  late Future<List<FpoApplication>> _applicationsFuture;
  _FpoFilter _filter = _FpoFilter.all;

  @override
  void initState() {
    super.initState();
    _applicationsFuture = widget.adminService.fetchApplications();
  }

  Future<void> _refresh() async {
    setState(() {
      _applicationsFuture = widget.adminService.fetchApplications(
        status: _filter == _FpoFilter.all ? null : _filter.toStatus(),
      );
    });
    await _applicationsFuture;
  }

  Future<void> _update(Future<FpoApplication> Function() action, String message) async {
    await action();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FPO Control')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FPO Review Queue', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Text('Approve, reject, request correction, suspend, or activate FPO accounts.'),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _FpoFilter.values.map((filter) {
                            final label = _labelFor(filter);
                            final selected = _filter == filter;
                            return ChoiceChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  _filter = filter;
                                  _applicationsFuture = widget.adminService.fetchApplications(
                                    status: filter == _FpoFilter.all ? null : filter.toStatus(),
                                  );
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<FpoApplication>>(
                    future: _applicationsFuture,
                    builder: (context, snapshot) {
                      final applications = snapshot.data ?? const <FpoApplication>[];
                      if (snapshot.connectionState == ConnectionState.waiting && applications.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (applications.isEmpty) {
                        return const AppCard(child: Text('No FPO applications found.'));
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: applications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final application = applications[index];
                          return AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                      child: Text(application.fpoName[0].toUpperCase()),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(application.fpoName, style: Theme.of(context).textTheme.titleMedium),
                                          const SizedBox(height: 4),
                                          Text('${application.registrationNumber} • ${application.state}, ${application.district}'),
                                        ],
                                      ),
                                    ),
                                    _statusChip(application.status),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _detailRow('Mobile', application.mobileNumber),
                                _detailRow('Submitted', _formatDate(application.submittedAt)),
                                _detailRow('Updated', _formatDate(application.updatedAt)),
                                if (application.reviewNote != null) _detailRow('Note', application.reviewNote!),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilledButton(
                                      onPressed: application.status == FpoApplicationStatus.pending
                                          ? () => _update(() => widget.adminService.approveApplication(application.id), 'FPO approved')
                                          : null,
                                      child: const Text('Approve'),
                                    ),
                                    OutlinedButton(
                                      onPressed: application.status == FpoApplicationStatus.pending
                                          ? () => _update(() => widget.adminService.requestCorrection(application.id, note: 'Please update supporting documents.'), 'Correction requested')
                                          : null,
                                      child: const Text('Request Correction'),
                                    ),
                                    OutlinedButton(
                                      onPressed: application.status == FpoApplicationStatus.pending || application.status == FpoApplicationStatus.approved
                                          ? () => _update(() => widget.adminService.rejectApplication(application.id, note: 'Rejected by super admin.'), 'FPO rejected')
                                          : null,
                                      child: const Text('Reject'),
                                    ),
                                    OutlinedButton(
                                      onPressed: application.status == FpoApplicationStatus.active
                                          ? () => _update(() => widget.adminService.suspendApplication(application.id, note: 'Suspended for review.'), 'FPO suspended')
                                          : null,
                                      child: const Text('Suspend'),
                                    ),
                                    OutlinedButton(
                                      onPressed: application.status == FpoApplicationStatus.approved
                                          ? () => _update(() => widget.adminService.activateApplication(application.id), 'FPO activated')
                                          : null,
                                      child: const Text('Activate'),
                                    ),
                                    TextButton(
                                      onPressed: () => showModalBottomSheet<void>(
                                        context: context,
                                        showDragHandle: true,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(application.fpoName, style: Theme.of(context).textTheme.titleLarge),
                                                  const SizedBox(height: 12),
                                                  Text('State: ${application.state}'),
                                                  Text('District: ${application.district}'),
                                                  Text('Registration: ${application.registrationNumber}'),
                                                  Text('Address: ${application.address}'),
                                                  Text('Certificate: ${application.certificateName}'),
                                                  if (application.additionalDocumentName != null) Text('Document: ${application.additionalDocumentName}'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      child: const Text('View Details'),
                                    ),
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

extension on _FpoFilter {
  FpoApplicationStatus? toStatus() {
    switch (this) {
      case _FpoFilter.all:
        return null;
      case _FpoFilter.pending:
        return FpoApplicationStatus.pending;
      case _FpoFilter.approved:
        return FpoApplicationStatus.approved;
      case _FpoFilter.active:
        return FpoApplicationStatus.active;
      case _FpoFilter.suspended:
        return FpoApplicationStatus.suspended;
      case _FpoFilter.rejected:
        return FpoApplicationStatus.rejected;
      case _FpoFilter.correctionRequired:
        return FpoApplicationStatus.correctionRequired;
    }
  }
}

String _labelFor(_FpoFilter filter) {
  switch (filter) {
    case _FpoFilter.all:
      return 'All';
    case _FpoFilter.pending:
      return 'Pending';
    case _FpoFilter.approved:
      return 'Approved';
    case _FpoFilter.active:
      return 'Active';
    case _FpoFilter.suspended:
      return 'Suspended';
    case _FpoFilter.rejected:
      return 'Rejected';
    case _FpoFilter.correctionRequired:
      return 'Correction';
  }
}

Widget _statusChip(FpoApplicationStatus status) {
  final color = switch (status) {
    FpoApplicationStatus.active => Colors.green,
    FpoApplicationStatus.approved => Colors.teal,
    FpoApplicationStatus.pending => Colors.orange,
    FpoApplicationStatus.suspended => Colors.red,
    FpoApplicationStatus.rejected => Colors.grey,
    FpoApplicationStatus.correctionRequired => Colors.deepOrange,
  };
  return Chip(label: Text(status.name), backgroundColor: color.withValues(alpha: 0.12), side: BorderSide(color: color));
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 94, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

String _formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}
