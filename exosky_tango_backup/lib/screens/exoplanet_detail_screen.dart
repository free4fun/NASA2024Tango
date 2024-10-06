import 'package:flutter/material.dart';
import '../models/exoplanet.dart';

class ExoplanetDetailScreen extends StatelessWidget {
  final Exoplanet exoplanet;

  const ExoplanetDetailScreen({super.key, required this.exoplanet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exoplanet.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Nombre', exoplanet.name),
            _buildDetailRow(
                'Año de descubrimiento', exoplanet.discoveryYear.toString()),
            _buildDetailRow('Distancia (años luz)',
                exoplanet.distance?.toStringAsFixed(2) ?? 'Desconocida'),
            _buildDetailRow('Masa (Masas terrestres)',
                exoplanet.mass?.toStringAsFixed(2) ?? 'Desconocida'),
            _buildDetailRow('Radio (Radios terrestres)',
                exoplanet.radius?.toStringAsFixed(2) ?? 'Desconocido'),
            _buildDetailRow(
                'Tipo de estrella', exoplanet.starType ?? 'Desconocido'),
            _buildDetailRow('Temperatura (K)',
                exoplanet.temperature?.toStringAsFixed(0) ?? 'Desconocida'),
            _buildDetailRow('Ascensión recta',
                exoplanet.rightAscension?.toStringAsFixed(4) ?? 'Desconocida'),
            _buildDetailRow('Declinación',
                exoplanet.declination?.toStringAsFixed(4) ?? 'Desconocida'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
