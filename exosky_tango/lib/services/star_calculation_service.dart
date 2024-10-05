import 'dart:math';
import '../models/star.dart';
import '../models/exoplanet.dart';

class StarCalculationService {
  final Random _random = Random();

  List<Star> calculateVisibleStars(Exoplanet exoplanet, int starCount) {
    // Esta es una implementación simplificada. En un escenario real,
    // necesitarías cálculos astronómicos más complejos.
    List<Star> stars = [];

    for (int i = 0; i < starCount; i++) {
      stars.add(Star(
        name: 'Star-${i + 1}',
        rightAscension: _random.nextDouble() * 24, // 0 a 24 horas
        declination: _random.nextDouble() * 180 - 90, // -90 a +90 grados
        magnitude: _random.nextDouble() * 6, // 0 a 6 (visible a simple vista)
        temperature: _random.nextDouble() * 30000 + 3000, // 3000K a 33000K
      ));
    }

    return stars;
  }

  // Aquí puedes agregar más métodos para cálculos astronómicos más precisos
}
