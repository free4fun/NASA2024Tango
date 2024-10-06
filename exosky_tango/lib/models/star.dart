/// Represents a star with its various properties.
class Star {
  final String sourceId;
  final double rightAscension;
  final double declination;
  final double? parallax;
  final double? magnitude;
  final double? temperature;
  final double? colorIndex;
  final String? properName;
  final double? radius;

  /// Creates a [Star] instance with the given properties.
  Star({
    required this.sourceId,
    required this.rightAscension,
    required this.declination,
    this.parallax,
    this.magnitude,
    this.temperature,
    this.colorIndex,
    this.properName,
    this.radius,
  });

  /// Creates a [Star] instance from a list of values.
  factory Star.fromList(List<String> cells) {
    return Star(
      sourceId: cells[0],
      rightAscension: double.parse(cells[1]),
      declination: double.parse(cells[2]),
      parallax: double.tryParse(cells[3]),
      magnitude: double.tryParse(cells[4]),
      temperature: double.tryParse(cells[5]),
      colorIndex: double.tryParse(cells[6]),
      radius: double.tryParse(cells[7]),
    );
  }

  /// Creates a [Star] instance from a list of values with detailed information.
  factory Star.fromDetailedList(List<dynamic> data) {
    return Star(
      sourceId: data[0] ?? '',
      rightAscension: double.tryParse(data[1] ?? '') ?? 0,
      declination: double.tryParse(data[2] ?? '') ?? 0,
      parallax: double.tryParse(data[3] ?? ''),
      magnitude: double.tryParse(data[4] ?? ''),
      temperature: double.tryParse(data[5] ?? ''),
      colorIndex: double.tryParse(data[6] ?? ''),
      radius: double.tryParse(data[7] ?? ''),
    );
  }

  /// Converts the [Star] instance to a map for JSON serialization.
  Map<String, dynamic> toJson() {
    return {
      'sourceId': sourceId,
      'rightAscension': rightAscension,
      'declination': declination,
      'parallax': parallax,
      'properName': properName,
      'magnitude': magnitude,
      'temperature': temperature,
      'colorIndex': colorIndex,
      'radius': radius,
    };
  }

  /// Calculates the distance in light-years based on parallax.
  double get distanceLightYears => parallax != null && parallax! > 0
      ? 3.26 / (parallax! / 1000)
      : double.infinity;

  @override
  String toString() {
    return 'Star(sourceId: $sourceId, properName: $properName, rightAscension: $rightAscension, declination: $declination)';
  }

  /// Creates a [Star] instance from a map of data.
  factory Star.fromMap(Map<String, dynamic> map) {
    return Star(
      sourceId: map['source_id'] as String? ?? '',
      rightAscension: double.tryParse(map['ra'] ?? '') ?? 0,
      declination: double.tryParse(map['dec'] ?? '') ?? 0,
      parallax: double.tryParse(map['parallax'] ?? ''),
      magnitude: double.tryParse(map['phot_g_mean_mag'] ?? ''),
      temperature: double.tryParse(map['teff_gspphot'] ?? ''),
      colorIndex: double.tryParse(map['bp_rp'] ?? ''),
      properName: map['proper_name'] as String?,
      radius: double.tryParse(map['radius_val'] ?? ''),
    );
  }
}
