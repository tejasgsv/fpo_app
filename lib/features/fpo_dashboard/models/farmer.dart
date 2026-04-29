class Farmer {
  const Farmer({
    required this.id,
    required this.name,
    required this.village,
    required this.landDetails,
    required this.cropDetails,
    this.fpoName = 'Current FPO',
  });

  final String id;
  final String name;
  final String village;
  final String landDetails;
  final String cropDetails;
  final String fpoName;
}

class FarmerDraft {
  const FarmerDraft({
    required this.name,
    required this.village,
    required this.landDetails,
    required this.cropDetails,
    this.fpoName = 'Current FPO',
  });

  final String name;
  final String village;
  final String landDetails;
  final String cropDetails;
  final String fpoName;
}