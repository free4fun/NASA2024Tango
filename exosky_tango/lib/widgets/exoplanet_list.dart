import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class ExoplanetList extends StatelessWidget {
  final List<Exoplanet> exoplanets;
  final Function(Exoplanet) onExoplanetSelected;

  const ExoplanetList({
    Key? key,
    required this.exoplanets,
    required this.onExoplanetSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exoplanets.length,
      itemBuilder: (context, index) {
        final exoplanet = exoplanets[index];
        return ListTile(
          title: Text(exoplanet.name ?? 'Unknown'),
          subtitle: Text(
              'Distance: ${exoplanet.distanceFromEarth?.toStringAsFixed(2) ?? 'Unknown'} ly'),
          onTap: () => onExoplanetSelected(exoplanet),
        );
      },
    );
  }
}
