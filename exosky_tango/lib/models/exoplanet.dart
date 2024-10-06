class Exoplanet {
  final String? name;
  final String? hostName;
  final int? numStars;
  final int? numPlanets;
  final String? discoveryMethod;
  final int? discoveryYear;
  final String? discoveryFacility;
  final double? orbitalPeriod;
  final double? planetRadius;
  final double? planetMass;
  final double? stellarEffectiveTemperature;
  final double? stellarRadius;
  final double? stellarMass;
  final double? eccentricity;
  final double? equilibriumTemperature;
  final double? rightAscension;
  final double? declination;
  final double? distanceFromEarth;
  final String? stellarSpectralType;

  Exoplanet({
    this.name,
    this.hostName,
    this.numStars,
    this.numPlanets,
    this.discoveryMethod,
    this.discoveryYear,
    this.discoveryFacility,
    this.orbitalPeriod,
    this.planetRadius,
    this.planetMass,
    this.stellarEffectiveTemperature,
    this.stellarRadius,
    this.stellarMass,
    this.eccentricity,
    this.equilibriumTemperature,
    this.rightAscension,
    this.declination,
    this.distanceFromEarth,
    this.stellarSpectralType,
  });

  /// Create an Exoplanet object from a list of values
  factory Exoplanet.fromList(List<String> data) {
    return Exoplanet(
      name: data[0],
      hostName: data[1],
      numStars: int.tryParse(data[2]),
      numPlanets: int.tryParse(data[3]),
      discoveryMethod: data[4],
      discoveryYear: int.tryParse(data[5]),
      discoveryFacility: data[6],
      orbitalPeriod: double.tryParse(data[7]),
      planetRadius: double.tryParse(data[8]),
      planetMass: double.tryParse(data[9]),
      stellarEffectiveTemperature: double.tryParse(data[10]),
      stellarRadius: double.tryParse(data[11]),
      stellarMass: double.tryParse(data[12]),
      eccentricity: double.tryParse(data[13]),
      equilibriumTemperature: double.tryParse(data[14]),
      rightAscension: double.tryParse(data[15]),
      declination: double.tryParse(data[16]),
      distanceFromEarth: double.tryParse(data[17]),
      stellarSpectralType: data[18],
    );
  }

  /// Create an Exoplanet object from a map
  factory Exoplanet.fromMap(Map<String, dynamic> map) {
    return Exoplanet(
      name: map['pl_name'],
      hostName: map['hostname'],
      numStars: int.tryParse(map['sy_snum'] ?? ''),
      numPlanets: int.tryParse(map['sy_pnum'] ?? ''),
      discoveryMethod: map['discoverymethod'],
      discoveryYear: int.tryParse(map['disc_year'] ?? ''),
      discoveryFacility: map['disc_facility'],
      orbitalPeriod: double.tryParse(map['pl_orbper'] ?? ''),
      planetRadius: double.tryParse(map['pl_rade'] ?? ''),
      planetMass: double.tryParse(map['pl_bmasse'] ?? ''),
      stellarEffectiveTemperature: double.tryParse(map['st_teff'] ?? ''),
      stellarRadius: double.tryParse(map['st_rad'] ?? ''),
      stellarMass: double.tryParse(map['st_mass'] ?? ''),
      eccentricity: double.tryParse(map['pl_orbeccen'] ?? ''),
      equilibriumTemperature: double.tryParse(map['pl_eqt'] ?? ''),
      rightAscension: double.tryParse(map['ra'] ?? ''),
      declination: double.tryParse(map['dec'] ?? ''),
      distanceFromEarth: double.tryParse(map['sy_dist'] ?? ''),
      stellarSpectralType: map['st_spectype'],
    );
  }
}
