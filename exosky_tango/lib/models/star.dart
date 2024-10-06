import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  final String id;
//  final String name;
  final double rightAscension;
  final double declination;
  final double? parallax;
  final double? apparentMagnitude;
  final double? colorIndex;
  final double? temperature;
  final double? radius;
  final double? luminosity;

  Star({
    required this.id,
    //required this.name,
    required this.rightAscension,
    required this.declination,
    this.parallax,
    required this.apparentMagnitude,
    required this.colorIndex,
    this.temperature,
    this.radius,
    this.luminosity,
  });
  factory Star.fromDetailedList(List<String> values) {
    return Star(
      id: values[0],
      rightAscension: double.parse(values[1]),
      declination: double.parse(values[2]),
      parallax: double.tryParse(values[3]),
      apparentMagnitude: double.tryParse(values[4]),
      temperature: double.tryParse(values[5]),
      colorIndex: double.tryParse(values[6]),
    );
  }

  factory Star.fromList(List<dynamic> data) {
    return Star(
      id: data[0].toString(),
      //name: _getStarName(data[0].toString(), data[1], data[2], data[9]),
      rightAscension: data[1],
      declination: data[2],
      parallax: data[3],
      apparentMagnitude: data[4],
      colorIndex: data[5],
      temperature: data[6],
      radius: data[7],
      luminosity: data[8],
    );
  }

  /// Generates a human-readable name for the star.
  static String _getStarName(
      String id, double ra, double dec, String? properName) {
    if (properName != null && properName.isNotEmpty) {
      return properName;
    }
    // Format: "Star HHMM±DDMM"
    int raHours = (ra / 15).floor();
    int raMinutes = ((ra / 15 - raHours) * 60).round();
    int decDegrees = dec.abs().floor();
    int decMinutes = ((dec.abs() - decDegrees) * 60).round();
    String decSign = dec >= 0 ? '+' : '-';
    return 'Star ${raHours.toString().padLeft(2, '0')}${raMinutes.toString().padLeft(2, '0')}$decSign${decDegrees.toString().padLeft(2, '0')}${decMinutes.toString().padLeft(2, '0')}';
  }

  /// Calculates the absolute magnitude of the star.
  double get absoluteMagnitude {
    if (parallax == null) return double.nan;
    return apparentMagnitude! - 5 * (log(100 / parallax!) / ln10);
  }

  /// Calculates the distance to the star in parsecs.
  double get distance {
    if (parallax == null || parallax! <= 0) return double.infinity;
    return 1000 / parallax!;
  }

  /// Returns a string representation of the star's spectral type.
  String get spectralType {
    if (temperature == null) return 'Unknown';
    if (temperature! > 30000) return 'O';
    if (temperature! > 10000) return 'B';
    if (temperature! > 7500) return 'A';
    if (temperature! > 6000) return 'F';
    if (temperature! > 5200) return 'G';
    if (temperature! > 3700) return 'K';
    return 'M';
  }

  /// Returns the color of the star based on its temperature.
  Color get color {
    if (temperature == null) return Colors.white;
    if (temperature! > 30000) return Colors.blue[900]!;
    if (temperature! > 10000) return Colors.blue[300]!;
    if (temperature! > 7500) return Colors.white;
    if (temperature! > 6000) return Colors.yellow[100]!;
    if (temperature! > 5200) return Colors.yellow;
    if (temperature! > 3700) return Colors.orange;
    return Colors.red;
  }
}
