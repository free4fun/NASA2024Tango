import 'package:flutter/material.dart';
import '../models/exoplanet.dart';

class ExoplanetList extends StatelessWidget {
  final List<Exoplanet> exoplanets;
  final bool isLoading;
  final VoidCallback onLoadMore;

  const ExoplanetList({
    super.key,
    required this.exoplanets,
    required this.isLoading,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exoplanets.length + 1,
      itemBuilder: (context, index) {
        if (index == exoplanets.length) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ElevatedButton(
              onPressed: onLoadMore,
              child: Text('Cargar más'),
            );
          }
        }

        final exoplanet = exoplanets[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(exoplanet.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(exoplanet.hostName),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Año de descubrimiento',
                        exoplanet.discoveryYear?.toString() ?? 'Desconocido'),
                    _buildInfoRow(
                        'Distancia',
                        exoplanet.distance != null
                            ? '${exoplanet.distance!.toStringAsFixed(2)} parsecs'
                            : 'Desconocido'),
                    _buildInfoRow(
                        'Masa',
                        exoplanet.mass != null
                            ? '${exoplanet.mass!.toStringAsFixed(2)} masas terrestres'
                            : 'Desconocido'),
                    _buildInfoRow(
                        'Radio',
                        exoplanet.radius != null
                            ? '${exoplanet.radius!.toStringAsFixed(2)} radios terrestres'
                            : 'Desconocido'),
                    _buildInfoRow('Tipo de estrella',
                        exoplanet.starType ?? 'Desconocido'),
                    _buildInfoRow(
                        'Temperatura',
                        exoplanet.temperature != null
                            ? '${exoplanet.temperature!.toStringAsFixed(0)} K'
                            : 'Desconocido'),
                    _buildInfoRow(
                        'Ascensión recta',
                        exoplanet.rightAscension?.toStringAsFixed(4) ??
                            'Desconocido'),
                    _buildInfoRow(
                        'Declinación',
                        exoplanet.declination?.toStringAsFixed(4) ??
                            'Desconocido'),
                    _buildInfoRow('Facilidad de descubrimiento',
                        exoplanet.discFacility ?? 'Desconocido'),
                    _buildInfoRow(
                        'Período orbital',
                        exoplanet.orbitalPeriod != null
                            ? '${exoplanet.orbitalPeriod!.toStringAsFixed(2)} días'
                            : 'Desconocido'),
                    _buildInfoRow(
                        'Excentricidad orbital',
                        exoplanet.orbitalEccentricity?.toStringAsFixed(3) ??
                            'Desconocido'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
