import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/widgets/star_chart.dart';
import 'package:exosky_tango/widgets/exoplanet_details_panel.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/models/exoplanet.dart';

class SkyViewScreen extends StatefulWidget {
  @override
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
  bool _showGrid = true;
  Exoplanet? _selectedExoplanet;
  Set<ExoplanetType> _visibleTypes = Set.from(ExoplanetType.values);

  // Define the visible range of the sky
  double _raMin = 0;
  double _raMax = 360; // 24 hours * 15 degrees per hour
  double _decMin = -90;
  double _decMax = 90;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load star and exoplanet data
  void _loadData() {
    final starProvider = Provider.of<StarProvider>(context, listen: false);
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    starProvider.fetchStars(
      raMin: _raMin,
      raMax: _raMax,
      decMin: _decMin,
      decMax: _decMax,
    );
    exoplanetProvider.fetchExoplanets();
  }

  // Handle exoplanet selection
  void _onExoplanetSelected(Exoplanet? exoplanet) {
    setState(() {
      _selectedExoplanet = exoplanet;
    });
  }

  // Toggle visibility of exoplanet types
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

    return Scaffold(
      appBar: AppBar(
        title: Text('ExoSky Tango'),
        backgroundColor: Colors.black,
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
      body: starProvider.isLoading || exoplanetProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
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
                            raMin: _raMin,
                            raMax: _raMax,
                            decMin: _decMin,
                            decMax: _decMax,
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
                  child: ExoplanetDetailsPanel(exoplanet: _selectedExoplanet),
                ),
              ],
            ),
    );
  }

  // Build the legend widget
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

  // Build individual legend items
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

  // Get color for each exoplanet type
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
