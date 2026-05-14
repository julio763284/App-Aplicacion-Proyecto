import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/HomePage.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/perfil.dart';
import 'package:gestor/Presentacion/Diseño/appbar.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  int _conteoNotificaciones = 0;

  @override
  void initState() {
    super.initState();
    _obtenerNotificaciones();
  }

  Future<void> _obtenerNotificaciones() async {
    final url = Uri.parse(ApiConfig.url('/notificaciones'));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        int noLeidas = data.where((n) => n['leido'] == 0 || n['leido'] == false).length;
        setState(() {
          _conteoNotificaciones = noLeidas;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),

      // cree una clase en la carpeta diseño para el appbar personalizado, y le pase el conteo de notificaciones y la función para actualizarlo
      appBar: CustomAppBar(
        conteoNotificaciones: _conteoNotificaciones,
        onActualizarNotificaciones: _obtenerNotificaciones,
      ),
      body: const HomepageBodyLayout(),
    );
  }
}

