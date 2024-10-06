import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exoplanet_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ExoskyTango());
}

class ExoskyTango extends StatelessWidget {
  const ExoskyTango({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExoplanetProvider(),
      child: MaterialApp(
        title: 'Explorador de Exoplanetas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
