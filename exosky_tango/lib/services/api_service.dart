import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:convert';
import 'package:exosky_tango/models/exoplanet.dart';
import 'package:exosky_tango/models/star.dart';

/// Service class for handling API requests to NASA Exoplanet Archive and Gaia Archive.
class ApiService {
  static const String _nasaExoplanetUrl =
      'https://cors-anywhere.herokuapp.com/https://exoplanetarchive.ipac.caltech.edu/TAP/sync';
  static const String _gaiaUrl =
      'https://cors-anywhere.herokuapp.com/https://gea.esac.esa.int/tap-server/tap/sync';

  /// Fetches a list of exoplanets from the NASA Exoplanet Archive.
  ///
  /// [page] is the page number for pagination.
  /// [itemsPerPage] is the number of items to return per page.
  Future<List<Exoplanet>> getExoplanets({
    int page = 1,
    int itemsPerPage = 20,
  }) async {
    final baseUrl =
        'https://cors-anywhere.herokuapp.com/https://exoplanetarchive.ipac.caltech.edu/TAP/sync';
    final query = '''
    SELECT TOP $itemsPerPage
      pl_name, hostname, sy_snum, sy_pnum, discoverymethod, disc_year, disc_facility,
      pl_orbper, pl_rade, pl_bmasse, st_teff, st_rad, st_mass, pl_orbeccen,
      pl_eqt, ra, dec, sy_dist, st_spectype
    FROM ps
    ORDER BY pl_name
  ''';

    final encodedQuery = Uri.encodeQueryComponent(query);
    final url =
        '$baseUrl?REQUEST=doQuery&LANG=ADQL&FORMAT=votable&QUERY=$encodedQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final xmlDoc = XmlDocument.parse(response.body);
      final rows = xmlDoc.findAllElements('TR');
      return rows.map((row) {
        final cells =
            row.findAllElements('TD').map((cell) => cell.text).toList();
        return Exoplanet.fromList(cells);
      }).toList();
    } else {
      throw Exception(
          'Failed to load exoplanets: ${response.statusCode}\nBody: ${response.body}');
    }
  }

  /// Fetches a list of stars from the Gaia Archive.
  ///
  /// [raMin], [raMax], [decMin], [decMax] define the region of the sky to query.
  Future<List<Star>> getStars({
    double raMin = 0,
    double raMax = 360,
    double decMin = -90,
    double decMax = 90,
  }) async {
    print(
        "Starting getStars with parameters: raMin=$raMin, raMax=$raMax, decMin=$decMin, decMax=$decMax");

    final query = '''
    SELECT TOP 1000
      source_id, ra, dec, parallax, phot_g_mean_mag, bp_rp, teff_gspphot
    FROM gaiadr3.gaia_source
    WHERE ra BETWEEN $raMin AND $raMax
      AND dec BETWEEN $decMin AND $decMax
      AND parallax > 0
      AND phot_g_mean_mag IS NOT NULL
      AND bp_rp IS NOT NULL
      AND teff_gspphot IS NOT NULL
    ORDER BY phot_g_mean_mag ASC
    ''';

    final encodedQuery = Uri.encodeQueryComponent(query);
    final url =
        '$_gaiaUrl?REQUEST=doQuery&LANG=ADQL&FORMAT=json&QUERY=$encodedQuery';

    print("Request URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> rows = data['data'];
        print("Number of stars received: ${rows.length}");

        return rows.map((row) {
          return Star(
            id: row[0].toString(),
            rightAscension: double.parse(row[1].toString()),
            declination: double.parse(row[2].toString()),
            parallax: double.tryParse(row[3].toString()),
            apparentMagnitude: double.tryParse(row[4].toString()),
            colorIndex: double.tryParse(row[5].toString()),
            temperature: double.tryParse(row[6].toString()),
          );
        }).toList();
      } else {
        print("Error response body: ${response.body}");
        throw Exception('Failed to load stars: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stars: $e');
      throw Exception('Error fetching stars: $e');
    }
  }

  /// Fetches details of a specific exoplanet from the NASA Exoplanet Archive.
  ///
  /// [planetName] is the name of the exoplanet to fetch.
  Future<Exoplanet> getExoplanetDetails(String planetName) async {
    final query = '''
      SELECT 
        pl_name, hostname, sy_snum, sy_pnum, discoverymethod,
        disc_year, disc_facility, pl_orbper, pl_rade, pl_bmasse,
        st_teff, st_rad, st_mass, pl_orbeccen, pl_eqt, ra, dec,
        sy_dist, st_spectype
      FROM ps
      WHERE pl_name = '$planetName'
      AND default_flag = 1
    ''';

    try {
      final response = await http.get(
        Uri.parse(
            '$_nasaExoplanetUrl?query=${Uri.encodeComponent(query)}&format=csv'),
      );

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        if (lines.length > 1) {
          final headers = lines[0].split(',');
          final values = lines[1].split(',');
          final map = Map.fromIterables(headers, values);
          return Exoplanet.fromMap(map);
        }
        throw Exception('No data found for exoplanet: $planetName');
      } else {
        throw Exception(
            'Failed to load exoplanet details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching exoplanet details: $e');
      throw Exception('Error fetching exoplanet details: $e');
    }
  }

  /// Fetches details of a specific star from the Gaia Archive.
  ///
  /// [sourceId] is the Gaia source ID of the star to fetch.
  Future<Star> getStarDetails(String sourceId) async {
    final query = '''
  SELECT 
    source_id, ra, dec, parallax, phot_g_mean_mag, 
    teff_gspphot, bp_rp
  FROM gaiadr3.gaia_source
  WHERE source_id = '$sourceId'
''';

    try {
      final response = await http.get(
        Uri.parse(
            '$_gaiaUrl?query=${Uri.encodeComponent(query)}&format=csv&LANG=ADQL&REQUEST=doQuery'),
      );

      if (response.statusCode == 200) {
        final List<String> lines = response.body.split('\n');
        if (lines.length > 1) {
          final values = lines[1].split(',');
          return Star.fromDetailedList(values);
        }
        throw Exception('No data found for star with source ID: $sourceId');
      } else {
        throw Exception('Failed to load star details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching star details: $e');
      throw Exception('Error fetching star details: $e');
    }
  }
}
