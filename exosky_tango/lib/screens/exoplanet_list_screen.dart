import 'package:flutter/material.dart';
import '../models/exoplanet.dart';
import 'sky_view_screen.dart';

class ExoplanetListScreen extends StatelessWidget {
  final List<Exoplanet> exoplanets = [
    Exoplanet(name: 'Kepler-186f', distance: 500),
    Exoplanet(name: 'Proxima Centauri b', distance: 4.2),
    Exoplanet(name: 'TRAPPIST-1e', distance: 39),
    // Agrega más exoplanetas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exoplanetas'),
      ),
      body: ListView.builder(
        itemCount: exoplanets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exoplanets[index].name),
            subtitle: Text('Distancia: ${exoplanets[index].distance} años luz'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SkyViewScreen(exoplanet: exoplanets[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
