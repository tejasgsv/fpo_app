import 'package:flutter/material.dart';

import 'package:fpo_app/core/constants/app_constants.dart';
import 'package:fpo_app/core/constants/app_strings.dart';
import 'package:fpo_app/features/auth/widgets/app_card.dart';
import 'package:fpo_app/features/auth/widgets/primary_button.dart';
import 'package:fpo_app/features/marketplace/models/product_listing.dart';
import 'package:fpo_app/features/marketplace/services/marketplace_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, required this.marketplaceService, required this.fpoName});

  final MarketplaceService marketplaceService;
  final String fpoName;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _availableDate;

  @override
  void dispose() {
    _cropController.dispose();
    _quantityController.dispose();
    _qualityController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _availableDate ?? DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      _availableDate = selectedDate;
      _dateController.text = '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
    });
  }

  Future<void> _saveListing() async {
    if (!_formKey.currentState!.validate() || _availableDate == null) {
      setState(() {});
      return;
    }

    await widget.marketplaceService.addListing(
      ProductDraft(
        cropName: _cropController.text.trim(),
        quantity: _quantityController.text.trim(),
        quality: _qualityController.text.trim(),
        location: _locationController.text.trim(),
        availableDate: _availableDate!,
        description: _descriptionController.text.trim(),
        fpoName: widget.fpoName,
      ),
    );

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addProductTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: AppCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.addProductTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cropController,
                      decoration: const InputDecoration(labelText: AppStrings.cropNameLabel),
                      validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: AppStrings.quantityLabel),
                      validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qualityController,
                      decoration: const InputDecoration(labelText: AppStrings.qualityLabel),
                      validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: AppStrings.locationLabel),
                      validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        labelText: AppStrings.availableDateLabel,
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (_) => _availableDate == null ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: AppStrings.descriptionLabel),
                      maxLines: 4,
                      validator: (value) => value == null || value.trim().isEmpty ? AppStrings.requiredFieldError : null,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(label: AppStrings.saveListing, onPressed: _saveListing),
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