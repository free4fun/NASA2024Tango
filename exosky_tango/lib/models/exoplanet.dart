/// Represents an exoplanet with its various properties.
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

  /// Creates an [Exoplanet] instance from a map of data.
  factory Exoplanet.fromMap(Map<String, dynamic> map) {
    return Exoplanet(
      name: map['pl_name'] as String?,
      hostName: map['hostname'] as String?,
      numStars: int.tryParse(map['sy_snum'] ?? ''),
      numPlanets: int.tryParse(map['sy_pnum'] ?? ''),
      discoveryMethod: map['discoverymethod'] as String?,
      discoveryYear: int.tryParse(map['disc_year'] ?? ''),
      discoveryFacility: map['disc_facility'] as String?,
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
      stellarSpectralType: map['st_spectype'] as String?,
    );
  }

  /// Converts the [Exoplanet] instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'pl_name': name,
      'hostname': hostName,
      'sy_snum': numStars,
      'sy_pnum': numPlanets,
      'discoverymethod': discoveryMethod,
      'disc_year': discoveryYear,
      'disc_facility': discoveryFacility,
      'pl_orbper': orbitalPeriod,
      'pl_rade': planetRadius,
      'pl_bmasse': planetMass,
      'st_teff': stellarEffectiveTemperature,
      'st_rad': stellarRadius,
      'st_mass': stellarMass,
      'pl_orbeccen': eccentricity,
      'pl_eqt': equilibriumTemperature,
      'ra': rightAscension,
      'dec': declination,
      'sy_dist': distanceFromEarth,
      'st_spectype': stellarSpectralType,
    };
  }

  @override
  String toString() {
    return 'Exoplanet(name: $name, hostName: $hostName)';
  }

  factory Exoplanet.fromList(List<String> cells) {
    return Exoplanet(
      name: cells[0],
      hostName: cells[1],
      numStars: int.tryParse(cells[2]),
      numPlanets: int.tryParse(cells[3]),
      discoveryMethod: cells[4],
      discoveryYear: int.tryParse(cells[5]),
      discoveryFacility: cells[6],
      orbitalPeriod: double.tryParse(cells[7]),
      planetRadius: double.tryParse(cells[8]),
      planetMass: double.tryParse(cells[9]),
      stellarEffectiveTemperature: double.tryParse(cells[10]),
      stellarRadius: double.tryParse(cells[11]),
      stellarMass: double.tryParse(cells[12]),
      eccentricity: double.tryParse(cells[13]),
      equilibriumTemperature: double.tryParse(cells[14]),
      rightAscension: double.tryParse(cells[15]),
      declination: double.tryParse(cells[16]),
      distanceFromEarth: double.tryParse(cells[17]),
      stellarSpectralType: cells[18],
    );
  }
}
