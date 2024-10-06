import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/constellation_service.dart';

class SavedConstellationsScreen extends StatelessWidget {
  const SavedConstellationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constelaciones Guardadas'),
      ),
      body: Consumer<ConstellationService>(
        builder: (context, constellationService, child) {
          final constellations = constellationService.constellations;
          return ListView.builder(
            itemCount: constellations.length,
            itemBuilder: (context, index) {
              final constellation = constellations[index];
              return ListTile(
                title: Text(constellation.name),
                subtitle: Text('${constellation.stars.length} estrellas'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    constellationService.removeConstellation(constellation);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
