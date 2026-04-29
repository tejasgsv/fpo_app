import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/widgets/app_card.dart';
import '../../fpo_dashboard/models/farmer.dart';
import '../../fpo_dashboard/services/farmer_service.dart';

class AdminFarmerDataScreen extends StatefulWidget {
  const AdminFarmerDataScreen({super.key, required this.farmerService});

  final FarmerService farmerService;

  @override
  State<AdminFarmerDataScreen> createState() => _AdminFarmerDataScreenState();
}

class _AdminFarmerDataScreenState extends State<AdminFarmerDataScreen> {
  late Future<List<Farmer>> _farmersFuture;
  String _selectedFpo = 'All';

  @override
  void initState() {
    super.initState();
    _farmersFuture = widget.farmerService.fetchFarmers();
  }

  Future<void> _refresh() async {
    setState(() {
      _farmersFuture = widget.farmerService.fetchFarmers();
    });
    await _farmersFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Data')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: FutureBuilder<List<Farmer>>(
                future: _farmersFuture,
                builder: (context, snapshot) {
                  final farmers = snapshot.data ?? const <Farmer>[];
                  final fpoOptions = <String>{'All', ...farmers.map((farmer) => farmer.fpoName)}.toList();
                  final filteredFarmers = _selectedFpo == 'All'
                      ? farmers
                      : farmers.where((farmer) => farmer.fpoName == _selectedFpo).toList(growable: false);

                  if (snapshot.connectionState == ConnectionState.waiting && farmers.isEmpty) {
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
                            Text('Farmer Registry', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            const Text('View farmers across all FPOs and filter records by ownership.'),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: fpoOptions
                                  .map(
                                    (option) => ChoiceChip(
                                      label: Text(option),
                                      selected: _selectedFpo == option,
                                      onSelected: (_) {
                                        setState(() {
                                          _selectedFpo = option;
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
                      if (filteredFarmers.isEmpty)
                        const AppCard(child: Text('No farmer records found.'))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredFarmers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final farmer = filteredFarmers[index];
                            return AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                                        child: Text(farmer.name[0].toUpperCase()),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(farmer.name, style: Theme.of(context).textTheme.titleMedium),
                                            const SizedBox(height: 4),
                                            Text('${farmer.fpoName} • ${farmer.village}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _row('Land', farmer.landDetails),
                                  _row('Crops', farmer.cropDetails),
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

Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
