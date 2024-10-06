import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/exoplanet.dart';

class ExoplanetChart extends StatelessWidget {
  final List<Exoplanet> exoplanets;

  const ExoplanetChart({super.key, required this.exoplanets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: exoplanets.map((exoplanet) {
            return ScatterSpot(
              exoplanet.mass ?? 0,
              exoplanet.radius ?? 0,
              dotPainter: FlDotCirclePainter(
                color: Colors.blue,
                strokeWidth: 1,
                strokeColor: Colors.blue,
              ),
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              axisNameWidget: const Text('Masa (Masas terrestres)'),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              axisNameWidget: const Text('Radio (Radios terrestres)'),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}
