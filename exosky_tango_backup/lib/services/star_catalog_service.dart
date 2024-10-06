import 'package:dio/dio.dart';
import 'dart:math';
import '../models/exoplanet.dart';

class StarCatalogService {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://cors-anywhere.herokuapp.com/https://exoplanetarchive.ipac.caltech.edu/TAP/sync';

  Future<List<Exoplanet>> getExoplanets(
      {int page = 1, int itemsPerPage = 20}) async {
    final query = '''
      SELECT 
        pl_name, 
        hostname, 
        sy_snum, 
        sy_pnum, 
        discoverymethod,
        disc_year, 
        disc_facility, 
        pl_orbper, 
        pl_rade, 
        pl_bmasse, 
        st_teff,
        st_rad,
        st_mass,
        pl_orbeccen, 
        pl_eqt, 
        ra, 
        dec, 
        sy_dist, 
        st_spectype
      FROM ps
      WHERE default_flag = 1
      ORDER BY pl_name
    ''';

    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'query': query,
          'format': 'csv',
          'TOP': itemsPerPage.toString(),
          'OFFSET': ((page - 1) * itemsPerPage).toString(),
        },
      );

      print('Código de estado de la respuesta: ${response.statusCode}');
      print('Tipo de datos de la respuesta: ${response.data.runtimeType}');
      print('Longitud de la respuesta: ${response.data.length}');
      print('Primeros 200 caracteres de la respuesta:');
      print(response.data
          .toString()
          .substring(0, min(200, response.data.toString().length)));

      if (response.statusCode == 200) {
        final csvString = response.data as String;
        if (csvString.trim().isEmpty) {
          throw Exception('La respuesta CSV está vacía');
        }

        // Dividir manualmente las líneas del CSV
        final List<String> lines = csvString.split('\n');
        print('Número de líneas en el CSV: ${lines.length}');

        if (lines.length > 1) {
          final headers = lines[0].split(',');
          print('Encabezados: $headers');

          final List<Exoplanet> exoplanets = [];
          for (int i = 1; i < lines.length; i++) {
            if (lines[i].trim().isNotEmpty) {
              final List<String> values = _parseCSVLine(lines[i]);
              if (values.length == headers.length) {
                exoplanets.add(Exoplanet.fromCsvRow(headers, values));
              }
            }
          }

          print('Número de exoplanetas procesados: ${exoplanets.length}');
          return exoplanets;
        } else {
          throw Exception('No se encontraron datos en la respuesta CSV');
        }
      } else {
        throw Exception('Error al cargar exoplanetas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener exoplanetas: $e');
      throw Exception('Error al obtener exoplanetas: $e');
    }
  }

  List<String> _parseCSVLine(String line) {
    List<String> result = [];
    bool inQuotes = false;
    StringBuffer currentValue = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      if (line[i] == '"') {
        inQuotes = !inQuotes;
      } else if (line[i] == ',' && !inQuotes) {
        result.add(currentValue.toString().trim());
        currentValue.clear();
      } else {
        currentValue.write(line[i]);
      }
    }

    if (currentValue.isNotEmpty) {
      result.add(currentValue.toString().trim());
    }

    return result;
  }
}
