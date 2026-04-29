import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/state/platform_store.dart';
import '../services/auth_service.dart';
import '../widgets/app_card.dart';
import '../widgets/primary_button.dart';

class AccessStatusScreen extends StatelessWidget {
  const AccessStatusScreen({super.key, required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    final status = session.accountStatus ?? FpoApplicationStatus.pending;
    final theme = Theme.of(context);

    String title;
    String message;
    IconData icon;
    bool active;

    switch (status) {
      case FpoApplicationStatus.active:
        title = 'Activation complete';
        message = 'Your FPO is active and ready for the dashboard.';
        icon = Icons.verified_outlined;
        active = true;
      case FpoApplicationStatus.approved:
        title = 'Approved, waiting activation';
        message = 'The admin has approved your FPO. Activation is the next step.';
        icon = Icons.hourglass_top_outlined;
        active = false;
      case FpoApplicationStatus.suspended:
        title = 'Account suspended';
        message = 'This FPO is currently suspended. Contact the admin team for review.';
        icon = Icons.pause_circle_outline;
        active = false;
      case FpoApplicationStatus.rejected:
        title = 'Registration rejected';
        message = 'The current registration request was rejected by the admin.';
        icon = Icons.cancel_outlined;
        active = false;
      case FpoApplicationStatus.correctionRequired:
        title = 'Correction required';
        message = 'Please update the submitted details and resubmit the registration.';
        icon = Icons.edit_note_outlined;
        active = false;
      case FpoApplicationStatus.pending:
        title = 'Pending approval';
        message = 'Your FPO registration is under review by the super admin.';
        icon = Icons.hourglass_bottom_outlined;
        active = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(icon, color: theme.colorScheme.primary, size: 38),
                    ),
                    const SizedBox(height: 20),
                    Text(title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(message, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('FPO:'),
                        const SizedBox(width: 8),
                        Expanded(child: Text(session.displayName, style: const TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Status:'),
                        const SizedBox(width: 8),
                        Expanded(child: Text(status.name)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: active ? 'Open Dashboard' : 'Back to Login',
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          active ? AppRoutes.dashboard : AppRoutes.login,
                          (route) => false,
                          arguments: active ? session : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
