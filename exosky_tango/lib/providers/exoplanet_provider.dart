import 'package:flutter/foundation.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/services/api_service.dart';
import 'dart:math' show sqrt, pow, pi;

class ExoplanetProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Exoplanet> _exoplanets = [];
  Exoplanet? _selectedExoplanet;
  bool _isLoading = false;
  String? _error;

  List<Exoplanet> get exoplanets => _exoplanets;
  Exoplanet? get selectedExoplanet => _selectedExoplanet;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch exoplanets from the API
  Future<void> fetchExoplanets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exoplanets = await _apiService.getExoplanets();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error fetching exoplanets: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select an exoplanet
  void selectExoplanet(Exoplanet exoplanet) {
    _selectedExoplanet = exoplanet;
    notifyListeners();
  }

  /// Deselect the current exoplanet
  void deselectExoplanet() {
    _selectedExoplanet = null;
    notifyListeners();
  }

  /// Filter exoplanets based on distance from Earth
  List<Exoplanet> filterExoplanetsByDistance(double maxDistance) {
    return _exoplanets
        .where((exoplanet) =>
            exoplanet.distanceFromEarth != null &&
            exoplanet.distanceFromEarth! <= maxDistance)
        .toList();
  }

  /// Find exoplanets in the habitable zone
  List<Exoplanet> findHabitableExoplanets() {
    return _exoplanets.where((exoplanet) {
      if (exoplanet.stellarMass == null || exoplanet.orbitalPeriod == null) {
        return false;
      }
      // This is a simplified calculation and might need adjustment
      double innerEdge = 0.95 * sqrt(pow(exoplanet.stellarMass!, 4));
      double outerEdge = 1.37 * sqrt(pow(exoplanet.stellarMass!, 4));
      double semiMajorAxis = pow(
          exoplanet.stellarMass! * pow(exoplanet.orbitalPeriod! / 365.25, 2),
          1 / 3) as double;
      return semiMajorAxis >= innerEdge && semiMajorAxis <= outerEdge;
    }).toList();
  }

  /// Calculate the potential surface temperature of an exoplanet
  double? calculateSurfaceTemperature(Exoplanet exoplanet) {
    if (exoplanet.stellarRadius == null ||
        exoplanet.stellarEffectiveTemperature == null ||
        exoplanet.orbitalPeriod == null ||
        exoplanet.stellarMass == null) return null;

    // This is a simplified calculation and might need adjustment
    double semiMajorAxis = pow(
        exoplanet.stellarMass! * pow(exoplanet.orbitalPeriod! / 365.25, 2),
        1 / 3) as double;
    double stellarLuminosity = 4 *
        pi *
        pow(exoplanet.stellarRadius!, 2) *
        5.67e-8 *
        pow(exoplanet.stellarEffectiveTemperature!, 4);
    double equilibriumTemperature = pow(
        stellarLuminosity /
            (16 * pi * 5.67e-8 * pow(semiMajorAxis * 1.496e11, 2)),
        0.25) as double;

    return equilibriumTemperature;
  }
}
