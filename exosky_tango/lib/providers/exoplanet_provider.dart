import 'package:flutter/foundation.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/services/api_service.dart';

class ExoplanetProvider with ChangeNotifier {
  List<Exoplanet> _exoplanets = [];
  Exoplanet? _selectedExoplanet;
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Exoplanet> get exoplanets => _exoplanets;
  Exoplanet? get selectedExoplanet => _selectedExoplanet;
  bool get isLoading => _isLoading;
  String get error => _error;

  final ApiService _apiService = ApiService();

  // Set exoplanets and automatically select the first one if none is selected
  void setExoplanets(List<Exoplanet> exoplanets) {
    _exoplanets = exoplanets;
    if (_selectedExoplanet == null && exoplanets.isNotEmpty) {
      _selectedExoplanet = exoplanets.first;
    }
    notifyListeners();
  }

  // Set the selected exoplanet
  void setSelectedExoplanet(Exoplanet exoplanet) {
    _selectedExoplanet = exoplanet;
    notifyListeners();
  }

  // Fetch exoplanets from the API
  Future<void> fetchExoplanets() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _exoplanets = await _apiService.getExoplanets();
      if (_exoplanets.isNotEmpty && _selectedExoplanet == null) {
        _selectedExoplanet = _exoplanets.first;
      }
    } catch (e) {
      _error = 'Failed to fetch exoplanets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
