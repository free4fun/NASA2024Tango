import 'package:flutter/foundation.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:exosky_tango/services/api_service.dart';

class StarProvider with ChangeNotifier {
  List<Star> _stars = [];
  Star? _selectedStar;
  bool _isLoading = false;
  String? _error;

  List<Star> get stars => _stars;
  Star? get selectedStar => _selectedStar;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStars(
      {required double raMin,
      required double raMax,
      required double decMin,
      required double decMax}) async {
    try {
      final ApiService apiService = ApiService();
      final stars = await apiService.getStars(
          raMin: raMin, raMax: raMax, decMin: decMin, decMax: decMax);
      _stars = stars;
      notifyListeners();
      print("Estrellas cargadas en StarProvider: ${_stars.length}");
    } catch (e) {
      print("Error en fetchStars de StarProvider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectStar(Star star) {
    _selectedStar = star;
    notifyListeners();
  }
}
