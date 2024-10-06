import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class InfoOverlay extends StatelessWidget {
  final Exoplanet exoplanet;

  const InfoOverlay({Key? key, required this.exoplanet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exoplanet: ${exoplanet.name}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Host Star: ${exoplanet.hostName}',
                style: const TextStyle(color: Colors.white)),
            Text(
                'Distance: ${exoplanet.distanceFromEarth?.toStringAsFixed(2)} light years',
                style: const TextStyle(color: Colors.white)),
            Text(
                'Mass: ${exoplanet.planetMass?.toStringAsFixed(2)} Earth masses',
                style: const TextStyle(color: Colors.white)),
            Text(
                'Radius: ${exoplanet.planetRadius?.toStringAsFixed(2)} Earth radii',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
