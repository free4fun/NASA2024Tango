class Star {
  final int hipId;
  final double rightAscension;
  final double declination;
  final double visualMagnitude;
  final double effectiveTemperature;
  final String? name;

  Star({
    required this.hipId,
    required this.rightAscension,
    required this.declination,
    required this.visualMagnitude,
    required this.effectiveTemperature,
    required this.name,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    return Star(
      hipId: json['hip_id'] ?? 0,
      rightAscension: (json['ra'] ?? 0).toDouble(),
      declination: (json['dec'] ?? 0).toDouble(),
      visualMagnitude: (json['vmag'] ?? 0).toDouble(),
      effectiveTemperature: (json['teff'] ?? 0).toDouble(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hip_id': hipId,
      'ra': rightAscension,
      'dec': declination,
      'vmag': visualMagnitude,
      'teff': effectiveTemperature,
      'name': name,
    };
  }
}
