import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'modo_oscuro';

  bool _modoOscuro = true; // por defecto, igual que tu diseño actual
  bool get modoOscuro => _modoOscuro;

  ThemeProvider() {
    _cargarPreferencia();
  }

  Future<void> _cargarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    _modoOscuro = prefs.getBool(_prefKey) ?? true;
    notifyListeners();
  }

  Future<void> cambiarModo(bool oscuro) async {
    _modoOscuro = oscuro;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, oscuro);
  }

  ThemeMode get themeMode => _modoOscuro ? ThemeMode.dark : ThemeMode.light;
}