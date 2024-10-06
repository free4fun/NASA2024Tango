import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exoplanet.dart';
import '../services/star_calculation_service.dart';
import '../widgets/interactive_sky_view.dart';
import '../widgets/constellation_drawer.dart';

class SkyViewScreen extends StatelessWidget {
  final Exoplanet exoplanet;

  const SkyViewScreen({Key? key, required this.exoplanet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final starCalculationService = Provider.of<StarCalculationService>(context);
    final starPositions =
        starCalculationService.calculateStarPositions(exoplanet);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sky View from ${exoplanet.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveSkyView(
              starPositions: starPositions,
              child: ConstellationDrawer(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Exoplanet: ${exoplanet.name}\n'
              'Host Star: ${exoplanet.hostName}\n'
              'Distance: ${exoplanet.distance?.toStringAsFixed(2) ?? "Unknown"} light years',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
