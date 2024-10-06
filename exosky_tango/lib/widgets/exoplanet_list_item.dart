// lib/widgets/exoplanet_list_item.dart

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
      title: Text(
        exoplanet.name ?? 'Unknown',
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        'Distance: ${exoplanet.distanceFromEarth?.toStringAsFixed(2)} ly',
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      leading: _buildExoplanetIcon(),
      trailing: Icon(
        Icons.chevron_right,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      onTap: onTap,
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
    );
  }

  Widget _buildExoplanetIcon() {
    Color color;
    if (exoplanet.planetMass! < 1.0) {
      color = Colors.blue[200]!;
    } else if (exoplanet.planetMass! < 10.0) {
      color = Colors.blue[400]!;
    } else {
      color = Colors.blue[800]!;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          exoplanet.name!.substring(0, 1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
