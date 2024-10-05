import 'package:flutter/material.dart';
import '../models/exoplanet.dart';
import '../models/star.dart';
import '../widgets/interactive_sky_view.dart';
import '../services/star_calculation_service.dart';

class SkyViewScreen extends StatefulWidget {
  final Exoplanet exoplanet;

  SkyViewScreen({required this.exoplanet});

  @override
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
  late List<Star> stars;
  bool _isLoading = true;
  final StarCalculationService _starService = StarCalculationService();

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    // Usamos el StarCalculationService para obtener las estrellas visibles
    // desde el exoplaneta seleccionado.
    stars = _starService.calculateVisibleStars(widget.exoplanet, 1000);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista desde ${widget.exoplanet.name}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : InteractiveSkyView(
              exoplanet: widget.exoplanet,
              stars: stars,
            ),
    );
  }
}
