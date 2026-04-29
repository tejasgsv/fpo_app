class Farmer {
  const Farmer({
    required this.id,
    required this.name,
    required this.village,
    required this.landDetails,
    required this.cropDetails,
  });

  final String id;
  final String name;
  final String village;
  final String landDetails;
  final String cropDetails;
}

class FarmerDraft {
  const FarmerDraft({
    required this.name,
    required this.village,
    required this.landDetails,
    required this.cropDetails,
  });

  final String name;
  final String village;
  final String landDetails;
  final String cropDetails;
}