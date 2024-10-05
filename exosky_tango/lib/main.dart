import 'package:flutter/material.dart';
import 'screens/exoplanet_list_screen.dart';

void main() {
  runApp(ExoplanetSkyViewerApp());
}

class ExoplanetSkyViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exoplanet Sky Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExoplanetListScreen(),
    );
  }
}
