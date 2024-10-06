import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/widgets/star_chart.dart';
import 'package:exosky_tango/widgets/info_panel.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';

class SkyViewScreen extends StatefulWidget {
  const SkyViewScreen({Key? key}) : super(key: key);

  @override
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
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
    _loadData();
  }

  void _loadData() {
    final starProvider = Provider.of<StarProvider>(context, listen: false);
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    starProvider.fetchStars(
        raMin: raMin, raMax: raMax, decMin: decMin, decMax: decMax);
    exoplanetProvider.fetchExoplanets();
  }

  @override
  Widget build(BuildContext context) {
    final starProvider = Provider.of<StarProvider>(context);
    final exoplanetProvider = Provider.of<ExoplanetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ExoSky Explorer'),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onPanUpdate: (details) =>
                  setState(() => _offset += details.delta),
              onScaleUpdate: (details) =>
                  setState(() => _zoom = details.scale.clamp(0.5, 5.0)),
              child: StarChart(
                stars: starProvider.stars,
                exoplanets: exoplanetProvider.exoplanets,
                raMin: raMin,
                raMax: raMax,
                decMin: decMin,
                decMax: decMax,
                showGrid: _showGrid,
                zoom: _zoom,
                offset: _offset,
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

  void _exportData() {
    print('Exporting data...');
  }
}
