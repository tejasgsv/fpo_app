import '../models/farmer.dart';

abstract class FarmerService {
  Future<List<Farmer>> fetchFarmers();

  Future<Farmer> addFarmer(FarmerDraft draft);

  Future<Farmer?> getFarmer(String farmerId);
}

class MockFarmerService implements FarmerService {
  MockFarmerService()
      : _farmers = [
          const Farmer(
            id: 'farmer_1',
            name: 'Aman Singh',
            village: 'Bhavani Nagar',
            landDetails: '3.5 acres, irrigated',
            cropDetails: 'Wheat and mustard',
            fpoName: 'Sahyadri FPO',
          ),
          const Farmer(
            id: 'farmer_2',
            name: 'Sonia Patel',
            village: 'Kheda',
            landDetails: '2.1 acres, rain-fed',
            cropDetails: 'Cotton and groundnut',
            fpoName: 'Krushi Mitra FPO',
          ),
          const Farmer(
            id: 'farmer_3',
            name: 'Rakesh Yadav',
            village: 'Barabanki',
            landDetails: '4.0 acres, mixed soil',
            cropDetails: 'Rice, vegetables, pulses',
            fpoName: 'Delta Farmers FPO',
          ),
        ];

  final List<Farmer> _farmers;

  @override
  Future<Farmer> addFarmer(FarmerDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final farmer = Farmer(
      id: 'farmer_${DateTime.now().millisecondsSinceEpoch}',
      name: draft.name,
      village: draft.village,
      landDetails: draft.landDetails,
      cropDetails: draft.cropDetails,
      fpoName: draft.fpoName,
    );
    _farmers.insert(0, farmer);
    return farmer;
  }

  @override
  Future<Farmer?> getFarmer(String farmerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _farmers.cast<Farmer?>().firstWhere(
          (farmer) => farmer?.id == farmerId,
          orElse: () => null,
        );
  }

  @override
  Future<List<Farmer>> fetchFarmers() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return List<Farmer>.unmodifiable(_farmers);
  }
}