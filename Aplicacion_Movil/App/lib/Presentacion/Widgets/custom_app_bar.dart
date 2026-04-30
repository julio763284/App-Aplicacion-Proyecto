import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/perfil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget; // Para el buscador
  final int notificationCount;
  final bool showNotifications;
  final bool showProfile;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onRefreshNotifications;

  const CustomAppBar({
    super.key,
    this.title = "NEXUS INVENTORY",
    this.titleWidget,
    this.notificationCount = 0,
    this.showNotifications = true,
    this.showProfile = true,
    this.onSearchPressed,
    this.onRefreshNotifications,
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
      // Si hay un titleWidget (buscador), lo muestra, si no, el texto normal
      title: titleWidget ?? Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        if (onSearchPressed != null)
          IconButton(
            // Cambia el icono si está abierto el buscador
            icon: Icon(titleWidget == null ? Icons.search : Icons.close, color: Colors.white70),
            onPressed: onSearchPressed,
          ),
        if (showNotifications)
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none, color: Colors.white70, size: 28),
                if (notificationCount > 0)
                  Positioned(
                    right: -2, top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text('$notificationCount', 
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    ),
                  ),
              ],
            ),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView()));
              if (onRefreshNotifications != null) onRefreshNotifications!();
            },
          ),
        if (showProfile)
          IconButton(
            icon: const Icon(Icons.person_pin, color: Colors.greenAccent, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage(
                nombre: 'JHOLIAN MANUEL',
                email: 'jholianmanuel@gmail.com',
                urlImagen: 'https://avatars.githubusercontent.com/u/12345678?v=4',
              )));
            },
          ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}