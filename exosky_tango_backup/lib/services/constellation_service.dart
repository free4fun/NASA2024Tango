import 'package:flutter/foundation.dart';
import '../models/constellation.dart';
import '../models/star.dart'; // Añade esta línea
import 'cache_service.dart';

class ConstellationService extends ChangeNotifier {
  final List<Constellation> _constellations = [];
  final CacheService _cacheService = CacheService();

  List<Constellation> get constellations => _constellations;

  Future<void> loadConstellations() async {
    final cachedConstellations =
        await _cacheService.getCachedData('constellations');
    if (cachedConstellations != null) {
      _constellations.clear();
      _constellations.addAll(cachedConstellations.map((data) => Constellation(
            name: data['name'],
            stars: (data['stars'] as List)
                .map((starData) => Star.fromJson(starData))
                .toList(),
          )));
      notifyListeners();
    }
  }

  Future<void> saveConstellation(Constellation constellation) async {
    _constellations.add(constellation);
    await _saveToCache();
    notifyListeners();
  }

  Future<void> removeConstellation(Constellation constellation) async {
    _constellations.remove(constellation);
    await _saveToCache();
    notifyListeners();
  }

  Future<void> _saveToCache() async {
    final List<Map<String, dynamic>> constellationData = _constellations
        .map((constellation) => {
              'name': constellation.name,
              'stars':
                  constellation.stars.map((star) => star.toJson()).toList(),
            })
        .toList();
    await _cacheService.cacheData('constellations', constellationData);
  }
}
