import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class ExoplanetDetailScreen extends StatelessWidget {
  final Exoplanet exoplanet;

  const ExoplanetDetailScreen({Key? key, required this.exoplanet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exoplanet.name ?? 'Exoplanet Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Host Star', exoplanet.hostName),
            _buildDetailRow('Discovery Method', exoplanet.discoveryMethod),
            _buildDetailRow(
                'Discovery Year', exoplanet.discoveryYear?.toString()),
            _buildDetailRow(
                'Orbital Period',
                exoplanet.orbitalPeriod != null
                    ? '${exoplanet.orbitalPeriod!.toStringAsFixed(2)} days'
                    : null),
            _buildDetailRow(
                'Planet Radius',
                exoplanet.planetRadius != null
                    ? '${exoplanet.planetRadius!.toStringAsFixed(2)} Earth radii'
                    : null),
            _buildDetailRow(
                'Planet Mass',
                exoplanet.planetMass != null
                    ? '${exoplanet.planetMass!.toStringAsFixed(2)} Earth masses'
                    : null),
            _buildDetailRow(
                'Stellar Temperature',
                exoplanet.stellarEffectiveTemperature != null
                    ? '${exoplanet.stellarEffectiveTemperature!.toStringAsFixed(0)} K'
                    : null),
            _buildDetailRow(
                'Stellar Radius',
                exoplanet.stellarRadius != null
                    ? '${exoplanet.stellarRadius!.toStringAsFixed(2)} Solar radii'
                    : null),
            _buildDetailRow(
                'Stellar Mass',
                exoplanet.stellarMass != null
                    ? '${exoplanet.stellarMass!.toStringAsFixed(2)} Solar masses'
                    : null),
            _buildDetailRow(
                'Eccentricity', exoplanet.eccentricity?.toStringAsFixed(4)),
            _buildDetailRow(
                'Equilibrium Temperature',
                exoplanet.equilibriumTemperature != null
                    ? '${exoplanet.equilibriumTemperature!.toStringAsFixed(0)} K'
                    : null),
            _buildDetailRow(
                'Distance from Earth',
                exoplanet.distanceFromEarth != null
                    ? '${exoplanet.distanceFromEarth!.toStringAsFixed(2)} light-years'
                    : null),
            _buildDetailRow(
                'Stellar Spectral Type', exoplanet.stellarSpectralType),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value ?? 'Unknown'),
          ),
        ],
      ),
    );
  }
}
