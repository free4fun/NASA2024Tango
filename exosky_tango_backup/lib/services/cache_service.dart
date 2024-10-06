import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheService {
  static const String starsCacheKey = 'stars_cache';
  static const String exoplanetsCacheKey = 'exoplanets_cache';

  Future<void> cacheData(String key, List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

  Future<List<dynamic>?> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(key);
    if (cachedData != null) {
      return json.decode(cachedData);
    }
    return null;
  }
}
