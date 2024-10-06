import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exosky_tango/screens/home_screen.dart';
import 'package:exosky_tango/providers/star_provider.dart';
import 'package:exosky_tango/providers/exoplanet_provider.dart';

Future<void> main() async {
  runApp(ExoSkyTangoApp());
}

class ExoSkyTangoApp extends StatelessWidget {
  const ExoSkyTangoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StarProvider()),
        ChangeNotifierProvider(create: (_) => ExoplanetProvider()),
      ],
      child: MaterialApp(
        title: 'ExoSky Tango',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[900],
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
