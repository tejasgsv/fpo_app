import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../widgets/app_card.dart';
import '../widgets/primary_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.dashboard_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.dashboardTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(AppStrings.dashboardBody),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: AppStrings.registerFpo,
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.registerFpo);
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
