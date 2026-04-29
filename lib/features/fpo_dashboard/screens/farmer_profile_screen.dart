import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/fpo_dashboard/models/farmer.dart';
import 'package:fpo_app/features/fpo_dashboard/services/farmer_service.dart';

class FarmerProfileScreen extends StatelessWidget {
  const FarmerProfileScreen({super.key, required this.farmerService, required this.farmerId});

  final FarmerService farmerService;
  final String farmerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.farmerProfileTitle)),
      body: FutureBuilder<Farmer?>(
        future: farmerService.getFarmer(farmerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final farmer = snapshot.data;
          if (farmer == null) {
            return const Center(child: Text(AppStrings.noFarmerFound));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(farmer.name, style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(farmer.village),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProfileRow(label: AppStrings.landDetailsLabel, value: farmer.landDetails),
                          const SizedBox(height: 12),
                          _ProfileRow(label: AppStrings.cropDetailsLabel, value: farmer.cropDetails),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Operational notes', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          const Text('Profile data is mock-backed and ready to connect to API responses later.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(value)),
      ],
    );
  }
}