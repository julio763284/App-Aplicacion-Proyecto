import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/HomePage.dart'; // Asumo que aquí está HomepageBodyLayout
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/perfil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final int conteoNotificaciones;
  final VoidCallback? alActualizarNotificaciones;
  final bool mostrarNotificaciones;
  final bool mostrarPerfil;

  const CustomAppBar({
    super.key,
    required this.titulo,
    required this.conteoNotificaciones,
    this.alActualizarNotificaciones,
    this.mostrarNotificaciones = true,
    this.mostrarPerfil = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        if (mostrarNotificaciones)
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white70,
                  size: 28,
                ),
                if (conteoNotificaciones > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$conteoNotificaciones',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationView(),
                ),
              );
              if (alActualizarNotificaciones != null) {
                alActualizarNotificaciones!();
              }
            },
          ),
        if (mostrarPerfil)
          IconButton(
            icon: const Icon(
              Icons.person_pin,
              color: Colors.greenAccent,
              size: 28,
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final String? userData = prefs.getString('user_data');
              int userId = 0;
              if (userData != null) {
                try {
                  final Map<String, dynamic> u = jsonDecode(userData);
                  userId = (u['id_usuario'] ?? u['id'] ?? u['userId']) is int
                      ? (u['id_usuario'] ?? u['id'] ?? u['userId']) as int
                      : int.tryParse(
                              (u['id_usuario'] ?? u['id'] ?? u['userId'])
                                  .toString(),
                            ) ??
                            0;
                } catch (_) {
                  userId = 0;
                }
              }
              if (userId == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilPage(userId: userId),
                  ),
                );
              }
            },
          ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
        int noLeidas = data
            .where((n) => n['leido'] == 0 || n['leido'] == false)
            .length;
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

      appBar: CustomAppBar(
        titulo: "NEXUS INVENTORY",
        conteoNotificaciones: _conteoNotificaciones,
        alActualizarNotificaciones: _obtenerNotificaciones,
        mostrarNotificaciones: true,
        mostrarPerfil: true,
      ),

      body: const HomepageBodyLayout(),
    );
  }
}
