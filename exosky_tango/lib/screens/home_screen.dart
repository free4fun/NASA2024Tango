import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/widgets/star_chart.dart';
import 'package:exosky_tango/widgets/info_panel.dart';
import 'package:exosky_tango/widgets/exoplanet_details_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showGrid = true;
  Exoplanet? _selectedExoplanet;
  Set<ExoplanetType> _visibleTypes = Set.from(ExoplanetType.values);

  // Define the visible range of the sky
  final double raMin = 0;
  final double raMax = 360; // 24 hours * 15 degrees per hour
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
    print("Starting data loading");
    final starProvider = Provider.of<StarProvider>(context, listen: false);
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);

    try {
      print("Loading stars");
      await starProvider.fetchStars(
        raMin: raMin,
        raMax: raMax,
        decMin: decMin,
        decMax: decMax,
      );
      print("Stars loaded: ${starProvider.stars.length}");

      print("Loading exoplanets");
      await exoplanetProvider.fetchExoplanets();
      print("Exoplanets loaded: ${exoplanetProvider.exoplanets.length}");

      print("Data loading completed");
    } catch (e) {
      print('Error loading data: $e');
      // Consider showing a SnackBar or AlertDialog here to inform the user
    }
  }

  void _onExoplanetSelected(Exoplanet? exoplanet) {
    setState(() {
      _selectedExoplanet = exoplanet;
    });
  }

  void _toggleExoplanetType(ExoplanetType type) {
    setState(() {
      if (_visibleTypes.contains(type)) {
        _visibleTypes.remove(type);
      } else {
        _visibleTypes.add(type);
      }
    });
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
        body: Center(child: Text('No data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ExoSky Tango'),
        actions: [
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_off : Icons.grid_on),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    StarChart(
                      stars: starProvider.stars,
                      exoplanets: exoplanetProvider.exoplanets,
                      showGrid: _showGrid,
                      onExoplanetSelected: _onExoplanetSelected,
                      visibleTypes: _visibleTypes,
                      raMin: raMin,
                      raMax: raMax,
                      decMin: decMin,
                      decMax: decMax,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: _buildLegend(),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ExoplanetDetailsPanel(exoplanet: _selectedExoplanet),
                ),
                Expanded(
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
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exoplanet Types',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...ExoplanetType.values.map((type) => _buildLegendItem(type)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(ExoplanetType type) {
    return GestureDetector(
      onTap: () => _toggleExoplanetType(type),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _getExoplanetColor(type),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            type.toString().split('.').last,
            style: TextStyle(
              color: _visibleTypes.contains(type) ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Color _getExoplanetColor(ExoplanetType type) {
    switch (type) {
      case ExoplanetType.terrestrial:
        return Colors.blue;
      case ExoplanetType.gasGiant:
        return Colors.orange;
      case ExoplanetType.iceGiant:
        return Colors.cyan;
      case ExoplanetType.superEarth:
        return Colors.green;
      case ExoplanetType.unknown:
        return Colors.grey;
    }
  }
}
