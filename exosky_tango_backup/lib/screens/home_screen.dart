import 'package:flutter/material.dart';
import '../models/exoplanet.dart';
import '../services/star_catalog_service.dart';
import '../widgets/exoplanet_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StarCatalogService _starCatalogService = StarCatalogService();
  final List<Exoplanet> _exoplanets = [];
  bool _isLoading = false;
  int _currentPage = 1;
  static const int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadExoplanets();
  }

  Future<void> _loadExoplanets() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newExoplanets = await _starCatalogService.fetchExoplanets(
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
      );
      setState(() {
        _exoplanets.addAll(newExoplanets);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $errorMessage'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Reintentar',
          onPressed: _loadExoplanets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExoSky'),
      ),
      body: ExoplanetList(
        exoplanets: _exoplanets,
        isLoading: _isLoading,
        onLoadMore: _loadExoplanets,
      ),
    );
  }
}
