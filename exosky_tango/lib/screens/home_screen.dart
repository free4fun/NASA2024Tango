import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/widgets/star_chart.dart';
import 'package:exosky_tango/widgets/info_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showGrid = true;
  double _zoom = 1.0;
  Offset _offset = Offset.zero;

  final double raMin = 0;
  final double raMax = 360;
  final double decMin = -90;
  final double decMax = 90;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    print("Iniciando carga de datos");
    final starProvider = Provider.of<StarProvider>(context, listen: false);
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);

    try {
      print("Cargando estrellas");
      await starProvider.fetchStars(
        raMin: raMin,
        raMax: raMax,
        decMin: decMin,
        decMax: decMax,
      );
      print("Estrellas cargadas: ${starProvider.stars.length}");

      print("Cargando exoplanetas");
      await exoplanetProvider.fetchExoplanets();
      print("Exoplanetas cargados: ${exoplanetProvider.exoplanets.length}");

      print("Carga de datos completada");
    } catch (e) {
      print('Error loading data: $e');
      // Considera mostrar un SnackBar o un AlertDialog aquí para informar al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    final starProvider = Provider.of<StarProvider>(context);
    final exoplanetProvider = Provider.of<ExoplanetProvider>(context);

    if (starProvider.isLoading || exoplanetProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('ExoSky Tango')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (starProvider.stars.isEmpty && exoplanetProvider.exoplanets.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('ExoSky Tango')),
        body: Center(child: Text('No hay datos disponibles')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ExoSky Tango'),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () => setState(() => _showGrid = !_showGrid),
          ),
        ],
      ),
      body: starProvider.isLoading || exoplanetProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onScaleUpdate: (details) {
                      setState(() {
                        _zoom = details.scale.clamp(0.5, 5.0);
                        if (details.scale == 1.0) {
                          _offset += details.focalPointDelta;
                        }
                      });
                    },
                    child: StarChart(
                      raMin: raMin,
                      raMax: raMax,
                      decMin: decMin,
                      decMax: decMax,
                      showGrid: _showGrid,
                      zoom: _zoom,
                      offset: _offset,
                      stars: starProvider.stars,
                      exoplanets: exoplanetProvider.exoplanets,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InfoPanel(
                    stars: starProvider.stars,
                    exoplanets: exoplanetProvider.exoplanets,
                    fetchStars: () => starProvider.fetchStars(
                      raMin: raMin,
                      raMax: raMax,
                      decMin: decMin,
                      decMax: decMax,
                    ),
                    fetchExoplanets: exoplanetProvider.fetchExoplanets,
                  ),
                ),
              ],
            ),
    );
  }
}
