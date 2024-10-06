import 'package:flutter/material.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class ExoplanetListItem extends StatelessWidget {
  final Exoplanet exoplanet;
  final bool isSelected;
  final VoidCallback onTap;

  const ExoplanetListItem({
    Key? key,
    required this.exoplanet,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exoplanet.name ?? 'Unknown'),
      subtitle: Text(exoplanet.hostName ?? 'Unknown host'),
      trailing: Text(
        exoplanet.distanceFromEarth != null
            ? '${exoplanet.distanceFromEarth!.toStringAsFixed(2)} ly'
            : 'Unknown distance',
      ),
      selected: isSelected,
      onTap: onTap,
      tileColor: isSelected ? Colors.blueGrey[700] : null,
    );
  }
}
