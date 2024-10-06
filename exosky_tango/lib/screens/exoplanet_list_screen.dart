// lib/screens/exoplanet_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/widgets/exoplanet_list_item.dart';

class ExoplanetListScreen extends StatelessWidget {
  const ExoplanetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exoplanet Catalog'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Consumer<ExoplanetProvider>(
        builder: (context, exoplanetProvider, child) {
          if (exoplanetProvider.exoplanets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: exoplanetProvider.exoplanets.length,
            itemBuilder: (context, index) {
              final exoplanet = exoplanetProvider.exoplanets[index];
              return ExoplanetListItem(
                exoplanet: exoplanet,
                isSelected: exoplanet == exoplanetProvider.selectedExoplanet,
                onTap: () => _selectExoplanet(context, exoplanet),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterDialog(context),
        tooltip: 'Filter Exoplanets',
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  void _selectExoplanet(BuildContext context, Exoplanet exoplanet) {
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    exoplanetProvider.setSelectedExoplanet(exoplanet);
    Navigator.pop(context); // Return to the previous screen (likely HomeScreen)
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Exoplanets'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Add filter options here
                Text('Filter options will be implemented here.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                // Implement filter logic
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
