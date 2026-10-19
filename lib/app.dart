import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

/// Root widget: configures the theme (with the bundled Poppins font) and
/// shows the home screen.
class CampusEventExplorerApp extends StatelessWidget {
  const CampusEventExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Event Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3949AB)),
        fontFamily: 'Poppins',
        cardTheme: const CardThemeData(elevation: 2),
      ),
      home: const HomeScreen(),
    );
  }
}
