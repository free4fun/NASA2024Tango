import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class ExoplanetDetailsPanel extends StatelessWidget {
  final Exoplanet? exoplanet;
  final Function(Exoplanet?) onExoplanetChanged;

  const ExoplanetDetailsPanel({
    Key? key,
    required this.exoplanet,
    required this.onExoplanetChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (exoplanet == null) {
      return const Center(child: Text('Select an exoplanet to view details'));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exoplanet!.name ?? 'Unknown Exoplanet',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Distance',
              '${exoplanet!.distanceFromEarth?.toStringAsFixed(2) ?? 'Unknown'} ly'),
          _buildDetailRow('Mass',
              '${exoplanet!.planetMass?.toStringAsFixed(2) ?? 'Unknown'} Earth masses'),
          _buildDetailRow('Radius',
              '${exoplanet!.planetRadius?.toStringAsFixed(2) ?? 'Unknown'} Earth radii'),
          _buildDetailRow('Orbital Period',
              '${exoplanet!.orbitalPeriod?.toStringAsFixed(2) ?? 'Unknown'} days'),
          _buildDetailRow('Right Ascension',
              _formatRightAscension(exoplanet!.rightAscension)),
          _buildDetailRow('Declination',
              '${exoplanet!.declination?.toStringAsFixed(2) ?? 'Unknown'}°'),
          _buildDetailRow(
              'Discovery Method', exoplanet!.discoveryMethod ?? 'Unknown'),
          _buildDetailRow('Discovery Year',
              exoplanet!.discoveryYear?.toString() ?? 'Unknown'),
          _buildDetailRow('Host Star', exoplanet!.hostName ?? 'Unknown'),
          _buildDetailRow('Equilibrium Temperature',
              '${exoplanet!.equilibriumTemperature?.toStringAsFixed(2) ?? 'Unknown'} K'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onExoplanetChanged(null),
            child: const Text('Clear Selection'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String _formatRightAscension(double? ra) {
    if (ra == null) return 'Unknown';
    int hours = ra.floor();
    int minutes = ((ra - hours) * 60).floor();
    int seconds = (((ra - hours) * 60 - minutes) * 60).round();
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }
}
