import 'package:flutter/foundation.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:exosky_tango/services/api_service.dart';

class StarProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Star> _stars = [];
  bool _isLoading = false;
  String? _error;

  StarProvider(this._apiService);

  List<Star> get stars => _stars;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStars({
    required double raMin,
    required double raMax,
    required double decMin,
    required double decMax,
    int page = 1,
    int itemsPerPage = 1000,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final stars = await _apiService.getStars(
        raMin: raMin,
        raMax: raMax,
        decMin: decMin,
        decMax: decMax,
        page: page,
        itemsPerPage: itemsPerPage,
      );
      _stars = stars;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
