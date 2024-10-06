import 'package:flutter/foundation.dart';
import '../models/exoplanet.dart';
import '../services/star_catalog_service.dart';

class ExoplanetProvider with ChangeNotifier {
  final StarCatalogService _starCatalogService;
  List<Exoplanet> _exoplanets = [];
  List<Exoplanet> get exoplanets => _exoplanets;

  ExoplanetProvider(this._starCatalogService);

  Future<void> loadExoplanets() async {
    try {
      _exoplanets = await _starCatalogService.getExoplanets();
      notifyListeners();
    } catch (e) {
      print('Error loading exoplanets: $e');
    }
  }

  List<Exoplanet> filterExoplanets(String query) {
    return _exoplanets
        .where((exoplanet) =>
            exoplanet.name.toLowerCase().contains(query.toLowerCase()) ||
            exoplanet.hostName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
