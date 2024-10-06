import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/models/export_format.dart';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/services/export_service.dart';
import 'package:exosky_tango/widgets/export_dialog.dart';
import 'package:exosky_tango/widgets/star_chart.dart';
import 'package:exosky_tango/widgets/exoplanet_details_panel.dart';

class SkyViewScreen extends StatefulWidget {
  const SkyViewScreen({Key? key}) : super(key: key);

  @override
  _SkyViewScreenState createState() => _SkyViewScreenState();
}

class _SkyViewScreenState extends State<SkyViewScreen> {
  final ExportService _exportService = ExportService();
  bool _showGrid = true;
  Exoplanet? _selectedExoplanet;
  double _rightAscension = 0.0;
  double _declination = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    if (exoplanetProvider.exoplanets.isNotEmpty) {
      setState(() {
        _selectedExoplanet = exoplanetProvider.exoplanets.first;
        _updateChartPosition();
      });
    }
  }

  void _updateChartPosition() {
    if (_selectedExoplanet != null) {
      setState(() {
        _rightAscension = _selectedExoplanet!.rightAscension ?? 0.0;
        _declination = _selectedExoplanet!.declination ?? 0.0;
      });
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(
        onExport: (format) {
          Navigator.of(context).pop();
          _exportData(format);
        },
      ),
    );
  }

  void _exportData(ExportFormat format) async {
    final exoplanetProvider =
        Provider.of<ExoplanetProvider>(context, listen: false);
    List<Exoplanet> exoplanetsToExport = exoplanetProvider.exoplanets;

    try {
      await _exportService.exportData(exoplanetsToExport, format);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExoSky Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_on),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle grid',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _showExportDialog,
            tooltip: 'Export data',
          ),
        ],
      ),
      body: Consumer2<ExoplanetProvider, StarProvider>(
        builder: (context, exoplanetProvider, starProvider, child) {
          if (_selectedExoplanet == null) {
            return Center(child: Text('No exoplanet selected'));
          }
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: StarChart(
                  exoplanets: exoplanetProvider.exoplanets,
                  showGrid: true,
                  rightAscension: _rightAscension,
                  declination: _declination,
                ),
              ),
              Expanded(
                flex: 1,
                child: ExoplanetDetailsPanel(
                  exoplanet: _selectedExoplanet,
                  onExoplanetChanged: (Exoplanet? newExoplanet) {
                    if (newExoplanet != null) {
                      setState(() {
                        _selectedExoplanet = newExoplanet;
                        _updateChartPosition();
                      });
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
