import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exoplanet_provider.dart';
import '../widgets/exoplanet_list.dart';
import 'sky_view_screen.dart';

class ExoplanetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exoplanets'),
      ),
      body: Consumer<ExoplanetProvider>(
        builder: (context, exoplanetProvider, child) {
          if (exoplanetProvider.exoplanets.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ExoplanetList(
            exoplanets: exoplanetProvider.exoplanets,
            onExoplanetTap: (exoplanet) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SkyViewScreen(exoplanet: exoplanet),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
