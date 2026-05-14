import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/perfil.dart';
import 'package:http/http.dart' as http;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final int conteoNotificaciones;
  final VoidCallback onActualizarNotificaciones;

  const CustomAppBar({
    super.key,
    required this.conteoNotificaciones,
    required this.onActualizarNotificaciones,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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

      title: const Text(
        "NEXUS INVENTORY",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),

      actions: [

        // BOTÓN NOTIFICACIONES
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
            onActualizarNotificaciones();
          },
        ),

        // PERFIL
        IconButton(
          icon: const Icon(
            Icons.person_pin,
            color: Colors.greenAccent,
            size: 28,
          ),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PerfilPage(
                  userId: 1,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 5),
      ],
    );
  }
}