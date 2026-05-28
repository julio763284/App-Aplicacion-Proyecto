import 'dart:convert';
import 'package:flutter/material.dart';
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
    this.titulo = "NEXUS INVENTORY",
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
