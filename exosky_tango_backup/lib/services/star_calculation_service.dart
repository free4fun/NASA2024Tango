import 'dart:math';
import 'package:logging/logging.dart';
import '../models/star.dart';

/// A service class for performing calculations related to stars.
class StarCalculationService {
  final Logger _logger = Logger('StarCalculationService');

  /// Calculates the absolute magnitude of a star.
  ///
  /// The absolute magnitude is the magnitude the star would have if it were
  /// 10 parsecs (32.6 light-years) away from Earth.
  ///
  /// Parameters:
  /// [star] The star for which to calculate the absolute magnitude.
  /// [distance] The distance to the star in parsecs.
  ///
  /// Returns the calculated absolute magnitude.
  double calculateAbsoluteMagnitude(Star star, double distance) {
    if (distance <= 0) {
      throw ArgumentError('Distance must be greater than zero');
    }

    return star.visualMagnitude - 5 * (log(distance) / ln10 - 1);
  }

  /// Estimates the luminosity of a star relative to the Sun.
  ///
  /// Parameters:
  /// [absoluteMagnitude] The absolute magnitude of the star.
  ///
  /// Returns the luminosity of the star relative to the Sun.
  double estimateLuminosity(double absoluteMagnitude) {
    const double solarAbsoluteMagnitude = 4.83;
    return pow(10, (solarAbsoluteMagnitude - absoluteMagnitude) / 2.5)
        .toDouble();
  }

  /// Estimates the radius of a star relative to the Sun.
  ///
  /// Parameters:
  /// [luminosity] The luminosity of the star relative to the Sun.
  /// [temperature] The effective temperature of the star in Kelvin.
  ///
  /// Returns the radius of the star relative to the Sun.
  double estimateRadius(double luminosity, double temperature) {
    const double solarTemperature = 5778; // Kelvin
    return sqrt(luminosity) * pow(solarTemperature / temperature, 2);
  }

  /// Determines the spectral class of a star based on its effective temperature.
  ///
  /// Parameters:
  /// [temperature] The effective temperature of the star in Kelvin.
  ///
  /// Returns the spectral class as a string.
  String determineSpectralClass(double temperature) {
    if (temperature >= 30000) return 'O';
    if (temperature >= 10000) return 'B';
    if (temperature >= 7500) return 'A';
    if (temperature >= 6000) return 'F';
    if (temperature >= 5200) return 'G';
    if (temperature >= 3700) return 'K';
    return 'M';
  }

  /// Calculates and logs star information.
  ///
  /// Parameters:
  /// [star] The star for which to calculate information.
  /// [distance] The distance to the star in parsecs.
  void calculateAndLogStarInfo(Star star, double distance) {
    final absMag = calculateAbsoluteMagnitude(star, distance);
    final luminosity = estimateLuminosity(absMag);
    final radius = estimateRadius(luminosity, star.effectiveTemperature);
    final spectralClass = determineSpectralClass(star.effectiveTemperature);

    _logger.info('Summary for ${star.name ?? "HIP ${star.hipId}"}:');
    _logger.info('Visual magnitude: ${star.visualMagnitude}');
    _logger.info('Absolute magnitude: ${absMag.toStringAsFixed(2)}');
    _logger.info(
        'Luminosity: ${luminosity.toStringAsFixed(4)} times that of the Sun');
    _logger.info('Radius: ${radius.toStringAsFixed(4)} times that of the Sun');
    _logger.info('Effective temperature: ${star.effectiveTemperature} K');
    _logger.info('Spectral class: $spectralClass');
  }
}

// Example usage:
void main() {
  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final starService = StarCalculationService();

  // Create an instance of Star with sample data
  final star = Star(
    hipId: 87937,
    name: "Barnard's Star",
    rightAscension: 269.454,
    declination: 4.693,
    visualMagnitude: 9.54,
    effectiveTemperature: 3134,
  );

  // Assume we know the distance to this star (in parsecs)
  const distance = 1.8234; // Actual distance of Barnard's Star in parsecs

  starService.calculateAndLogStarInfo(star, distance);
}
