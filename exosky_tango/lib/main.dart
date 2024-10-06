import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/services/api_service.dart';
import 'package:exosky_tango/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExoplanetProvider()),
        ChangeNotifierProvider(create: (_) => StarProvider(ApiService())),
      ],
      child: ExoskyTangoApp(),
    ),
  );
}

class ExoskyTangoApp extends StatelessWidget {
  const ExoskyTangoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExoSky Tango',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
