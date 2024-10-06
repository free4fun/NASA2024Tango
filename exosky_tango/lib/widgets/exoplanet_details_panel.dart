import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class ExoplanetDetailsPanel extends StatelessWidget {
  final Exoplanet? exoplanet;

  const ExoplanetDetailsPanel({Key? key, this.exoplanet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child:
          exoplanet == null ? _buildNoSelectionInfo() : _buildExoplanetInfo(),
    );
  }

  Widget _buildNoSelectionInfo() {
    return Center(
      child: Text(
        'Select an exoplanet to view details',
        style: TextStyle(color: Colors.white70, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExoplanetInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exoplanet!.name ?? 'Unknown',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildInfoRow('Type', exoplanet!.type.toString().split('.').last),
        _buildInfoRow('Host Star', exoplanet!.hostName ?? 'Unknown'),
        _buildInfoRow('Distance',
            '${_formatValue(exoplanet!.distanceFromEarth)} light years'),
        _buildInfoRow(
            'Mass', '${_formatValue(exoplanet!.planetMass)} Jupiter masses'),
        _buildInfoRow(
            'Radius', '${_formatValue(exoplanet!.planetRadius)} Jupiter radii'),
        _buildInfoRow(
            'Orbital Period', '${_formatValue(exoplanet!.orbitalPeriod)} days'),
        _buildInfoRow('Eccentricity',
            _formatValue(exoplanet!.eccentricity, precision: 4)),
        _buildInfoRow(
            'Discovery Method', exoplanet!.discoveryMethod ?? 'Unknown'),
        _buildInfoRow('Discovery Year',
            exoplanet!.discoveryYear?.toString() ?? 'Unknown'),
        SizedBox(height: 16),
        _buildHabitabilityIndicator(),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String _formatValue(double? value, {int precision = 2}) {
    return value?.toStringAsFixed(precision) ?? 'Unknown';
  }

  Widget _buildHabitabilityIndicator() {
    // Simple habitability estimation based on orbital period
    // This is a very simplified approach and should be expanded for accuracy
    final orbitalPeriod = exoplanet!.orbitalPeriod ?? 0;
    final isHabitable = orbitalPeriod > 200 && orbitalPeriod < 500;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isHabitable
            ? Colors.green.withOpacity(0.3)
            : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isHabitable ? 'Potentially Habitable' : 'Not in Habitable Zone',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
