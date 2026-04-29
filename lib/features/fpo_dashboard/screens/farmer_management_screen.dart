import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_routes.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/auth/widgets/primary_button.dart';
import 'package:fpo_app/features/fpo_dashboard/models/farmer.dart';
import 'package:fpo_app/features/fpo_dashboard/services/farmer_service.dart';

class FarmerManagementScreen extends StatefulWidget {
  const FarmerManagementScreen({super.key, required this.farmerService});

  final FarmerService farmerService;

  @override
  State<FarmerManagementScreen> createState() => _FarmerManagementScreenState();
}

class _FarmerManagementScreenState extends State<FarmerManagementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _landController = TextEditingController();
  final TextEditingController _cropController = TextEditingController();

  late Future<List<Farmer>> _farmersFuture;

  @override
  void initState() {
    super.initState();
    _farmersFuture = widget.farmerService.fetchFarmers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _villageController.dispose();
    _landController.dispose();
    _cropController.dispose();
    super.dispose();
  }

  Future<void> _refreshFarmers() async {
    setState(() {
      _farmersFuture = widget.farmerService.fetchFarmers();
    });
    await _farmersFuture;
  }

  Future<void> _addFarmer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.farmerService.addFarmer(
      FarmerDraft(
        name: _nameController.text.trim(),
        village: _villageController.text.trim(),
        landDetails: _landController.text.trim(),
        cropDetails: _cropController.text.trim(),
      ),
    );

    _nameController.clear();
    _villageController.clear();
    _landController.clear();
    _cropController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farmer added')),
      );
      await _refreshFarmers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.farmerManagementTitle)),
      body: RefreshIndicator(
        onRefresh: _refreshFarmers,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.addFarmer, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: AppStrings.farmerNameLabel),
                            validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _villageController,
                            decoration: const InputDecoration(labelText: AppStrings.villageLabel),
                            validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _landController,
                            decoration: const InputDecoration(labelText: AppStrings.landDetailsLabel),
                            validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cropController,
                            decoration: const InputDecoration(labelText: AppStrings.cropDetailsLabel),
                            validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(label: AppStrings.saveFarmer, onPressed: _addFarmer),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(AppStrings.farmerListTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Farmer>>(
                    future: _farmersFuture,
                    builder: (context, snapshot) {
                      final farmers = snapshot.data ?? const <Farmer>[];
                      if (snapshot.connectionState == ConnectionState.waiting && farmers.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (farmers.isEmpty) {
                        return AppCard(
                          child: Text(AppStrings.noFarmersYet),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: farmers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final farmer = farmers[index];
                          return AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                      child: Text(farmer.name.isNotEmpty ? farmer.name[0].toUpperCase() : '?'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(farmer.name, style: Theme.of(context).textTheme.titleMedium),
                                          const SizedBox(height: 4),
                                          Text(farmer.village),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(AppRoutes.farmerProfile, arguments: farmer.id);
                                      },
                                      child: const Text('Profile'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _DetailRow(label: AppStrings.landDetailsLabel, value: farmer.landDetails),
                                const SizedBox(height: 8),
                                _DetailRow(label: AppStrings.cropDetailsLabel, value: farmer.cropDetails),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}