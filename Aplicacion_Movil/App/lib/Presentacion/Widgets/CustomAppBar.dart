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
    final theme = Theme.of(context);
    final cyan = theme.colorScheme.secondary;

    return AppBar(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: theme.iconTheme.color, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        titulo,
        style: theme.textTheme.bodyLarge?.copyWith(
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
                Icon(
                  Icons.notifications_none,
                  color: theme.iconTheme.color?.withOpacity(0.7),
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
                MaterialPageRoute(builder: (context) => const NotificationView()),
              );
              alActualizarNotificaciones?.call();
            },
          ),
        if (mostrarPerfil)
          IconButton(
            icon: Icon(Icons.person_pin, color: cyan, size: 28),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final String? userData = prefs.getString('user_data');
              int userId = 0;
              if (userData != null) {
                try {
                  final Map<String, dynamic> u = jsonDecode(userData);
                  userId = int.tryParse(
                        (u['id_usuario'] ?? u['id'] ?? u['userId']).toString(),
                      ) ?? 0;
                } catch (_) {
                  userId = 0;
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      userId == 0 ? const LoginPage() : PerfilPage(userId: userId),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}