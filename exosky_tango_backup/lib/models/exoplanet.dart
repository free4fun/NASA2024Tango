class Exoplanet {
  final String name;
  final String hostName;
  final double? rightAscension;
  final double? declination;
  final double? distance;
  final double? starTemperature;
  final double? starRadius;

  Exoplanet({
    required this.name,
    required this.hostName,
    this.rightAscension,
    this.declination,
    this.distance,
    this.starTemperature,
    this.starRadius,
  });

  factory Exoplanet.fromCsvRow(List<String> headers, List<String> values) {
    Map<String, String> rowData = Map.fromIterables(headers, values);

    return Exoplanet(
      name: rowData['pl_name'] ?? '',
      hostName: rowData['hostname'] ?? '',
      rightAscension: double.tryParse(rowData['ra'] ?? ''),
      declination: double.tryParse(rowData['dec'] ?? ''),
      distance: double.tryParse(rowData['sy_dist'] ?? ''),
      starTemperature: double.tryParse(rowData['st_teff'] ?? ''),
      starRadius: double.tryParse(rowData['st_rad'] ?? ''),
    );
  }

  @override
  String toString() {
    return 'Exoplanet(name: $name, hostName: $hostName)';
  }
}
