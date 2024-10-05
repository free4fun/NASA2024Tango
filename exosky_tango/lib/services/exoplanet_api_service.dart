import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import '../models/exoplanet.dart';

class ExoplanetApiService {
  final String baseUrl =
      'https://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI';

  Future<List<Exoplanet>> getExoplanets({int limit = 100}) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?table=ps&select=pl_name,pl_orbper,pl_rade,pl_masse,st_dist&format=csv&order=pl_name&where=default_flag=1'));

    if (response.statusCode == 200) {
      final List<List<dynamic>> rowsAsListOfValues =
          CsvToListConverter().convert(response.body);

      // Remove the header row
      rowsAsListOfValues.removeAt(0);

      return rowsAsListOfValues
          .take(limit)
          .map((row) => Exoplanet(
                name: row[0],
                //orbitalPeriod: double.tryParse(row[1] ?? '') ?? 0,
                //radius: double.tryParse(row[2] ?? '') ?? 0,
                //mass: double.tryParse(row[3] ?? '') ?? 0,
                distance: double.tryParse(row[4] ?? '') ?? 0,
              ))
          .toList();
    } else {
      throw Exception('Failed to load exoplanets');
    }
  }
}
