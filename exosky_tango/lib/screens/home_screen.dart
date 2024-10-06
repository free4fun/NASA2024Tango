import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/screens/sky_view_screen.dart'; // Cambia esta importación

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    final starProvider = Provider.of<StarProvider>(context, listen: false);

    await exoplanetProvider.fetchExoplanets();
    await starProvider.fetchStars(
      raMin: 0,
      raMax: 24,
      decMin: -90,
      decMax: 90,
      page: 1,
      itemsPerPage: 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ExoSky Tango')),
      body: Consumer2<ExoplanetProvider, StarProvider>(
        builder: (context, exoplanetProvider, starProvider, child) {
          print('Building Consumer2');
          print(
              'isLoading: ${exoplanetProvider.isLoading} || ${starProvider.isLoading}');
          print('Error: ${exoplanetProvider.error} ${starProvider.error}');
          print('Exoplanets count: ${exoplanetProvider.exoplanets.length}');

          if (exoplanetProvider.isLoading || starProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (exoplanetProvider.error.isNotEmpty ||
              starProvider.error != null) {
            return Center(
                child: Text(
                    'Error: ${exoplanetProvider.error} ${starProvider.error}'));
          } else if (exoplanetProvider.exoplanets.isEmpty) {
            return Center(child: Text('No exoplanets found'));
          } else {
            // Cambiamos SkyView por SkyViewScreen
            return SkyViewScreen();
          }
        },
      ),
    );
  }
}
