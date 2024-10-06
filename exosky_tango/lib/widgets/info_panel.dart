import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';
import 'package:exosky_tango/models/star.dart';
import 'package:exosky_tango/models/exoplanet.dart';

/// A widget that displays detailed information about selected stars and exoplanets.
class InfoPanel extends StatelessWidget {
  final List<Star> stars;
  final List<Exoplanet> exoplanets;
  final Future<void> Function() fetchStars;
  final Future<void> Function() fetchExoplanets;

  const InfoPanel({
    Key? key,
    required this.stars,
    required this.exoplanets,
    required this.fetchStars,
    required this.fetchExoplanets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedStar = context.watch<StarProvider>().selectedStar;
    final selectedExoplanet =
        context.watch<ExoplanetProvider>().selectedExoplanet;

    return Container(
      color: Colors.blueGrey[900],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedStar?.id ?? selectedExoplanet?.name ?? 'No selection',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16),
          if (selectedStar != null) _buildStarInfo(selectedStar),
          if (selectedExoplanet != null) _buildExoplanetInfo(selectedExoplanet),
        ],
      ),
    );
  }

  /// Builds the information display for a selected star.
  Widget _buildStarInfo(Star star) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoText('Type', 'Star', fontWeight: FontWeight.bold),
        _infoText('ID', star.id),
        _infoText(
            'Right Ascension', '${star.rightAscension.toStringAsFixed(4)}°'),
        _infoText('Declination', '${star.declination.toStringAsFixed(4)}°'),
        _infoText(
            'Apparent Magnitude', star.apparentMagnitude!.toStringAsFixed(2)),
        _infoText(
            'Absolute Magnitude',
            star.absoluteMagnitude.isFinite
                ? star.absoluteMagnitude.toStringAsFixed(2)
                : 'Unknown'),
        _infoText('Color Index', star.colorIndex!.toStringAsFixed(2)),
        _infoText('Spectral Type', star.spectralType),
        _infoText(
            'Temperature',
            star.temperature != null
                ? '${star.temperature!.toStringAsFixed(0)} K'
                : 'Unknown'),
        _infoText(
            'Distance',
            star.distance.isFinite
                ? '${star.distance.toStringAsFixed(2)} parsecs'
                : 'Unknown'),
        if (star.radius != null)
          _infoText('Radius', '${star.radius!.toStringAsFixed(2)} R☉'),
        if (star.luminosity != null)
          _infoText('Luminosity', '${star.luminosity!.toStringAsFixed(2)} L☉'),
      ],
    );
  }

  /// Builds the information display for a selected exoplanet.
  Widget _buildExoplanetInfo(Exoplanet exoplanet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoText('Type', 'Exoplanet', fontWeight: FontWeight.bold),
        _infoText('Name', exoplanet.name ?? 'Unknown'),
        _infoText('Host Star', exoplanet.hostName ?? 'Unknown'),
        _infoText(
            'Number of Stars', exoplanet.numStars?.toString() ?? 'Unknown'),
        _infoText(
            'Number of Planets', exoplanet.numPlanets?.toString() ?? 'Unknown'),
        _infoText('Discovery Method', exoplanet.discoveryMethod ?? 'Unknown'),
        _infoText(
            'Discovery Year', exoplanet.discoveryYear?.toString() ?? 'Unknown'),
        _infoText(
            'Discovery Facility', exoplanet.discoveryFacility ?? 'Unknown'),
        if (exoplanet.orbitalPeriod != null)
          _infoText('Orbital Period',
              '${exoplanet.orbitalPeriod!.toStringAsFixed(2)} days'),
        if (exoplanet.planetRadius != null)
          _infoText('Planet Radius',
              '${exoplanet.planetRadius!.toStringAsFixed(2)} R⊕'),
        if (exoplanet.planetMass != null)
          _infoText(
              'Planet Mass', '${exoplanet.planetMass!.toStringAsFixed(2)} M⊕'),
        if (exoplanet.stellarEffectiveTemperature != null)
          _infoText('Stellar Temperature',
              '${exoplanet.stellarEffectiveTemperature!.toStringAsFixed(0)} K'),
        if (exoplanet.stellarRadius != null)
          _infoText('Stellar Radius',
              '${exoplanet.stellarRadius!.toStringAsFixed(2)} R☉'),
        if (exoplanet.stellarMass != null)
          _infoText('Stellar Mass',
              '${exoplanet.stellarMass!.toStringAsFixed(2)} M☉'),
        if (exoplanet.eccentricity != null)
          _infoText('Eccentricity', exoplanet.eccentricity!.toStringAsFixed(4)),
        if (exoplanet.equilibriumTemperature != null)
          _infoText('Equilibrium Temperature',
              '${exoplanet.equilibriumTemperature!.toStringAsFixed(0)} K'),
        if (exoplanet.rightAscension != null)
          _infoText('Right Ascension',
              '${exoplanet.rightAscension!.toStringAsFixed(4)}°'),
        if (exoplanet.declination != null)
          _infoText(
              'Declination', '${exoplanet.declination!.toStringAsFixed(4)}°'),
        if (exoplanet.distanceFromEarth != null)
          _infoText('Distance from Earth',
              '${exoplanet.distanceFromEarth!.toStringAsFixed(2)} light-years'),
        _infoText('Stellar Spectral Type',
            exoplanet.stellarSpectralType ?? 'Unknown'),
      ],
    );
  }

  /// Helper method to create consistent text styling for information display.
  Widget _infoText(String label, String value,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.white70),
          children: [
            TextSpan(
                text: '$label: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value, style: TextStyle(fontWeight: fontWeight)),
          ],
        ),
      ),
    );
  }
}
