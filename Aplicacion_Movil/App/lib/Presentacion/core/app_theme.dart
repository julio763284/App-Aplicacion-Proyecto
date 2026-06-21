import 'package:flutter/material.dart';

class AppTheme {
  // Colores base de tu paleta "Nexus" actual
  static const Color accentTeal = Color(0xFF017A74);
  static const Color accentCyan = Color(0xFF00FBFF);

  static final ThemeData temaOscuro = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1B1E),
    primaryColor: accentTeal,
    colorScheme: const ColorScheme.dark(
      primary: accentTeal,
      secondary: accentCyan,
      surface: Color(0xFF162A2D),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    cardColor: const Color(0xFF162A2D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white24,
  );

  static final ThemeData temaClaro = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7F7),
    primaryColor: accentTeal,
    colorScheme: ColorScheme.light(
      primary: accentTeal,
      secondary: accentTeal,
      surface: Colors.white,
      onSurface: const Color(0xFF0D1B1E),
      onPrimary: Colors.white,
    ),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Color(0xFF0D1B1E),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF0D1B1E)),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF0D1B1E)),
    dividerColor: Colors.black12,
  );
}