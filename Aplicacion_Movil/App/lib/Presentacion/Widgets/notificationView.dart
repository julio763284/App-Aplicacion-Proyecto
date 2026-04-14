import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> notifications = []; // Aquí puedes llenar tu lista

  @override
  Widget build(BuildContext context) {
    // Color principal de Nexus Inventory
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      // 1. Agregamos el Drawer para que funcione el deslizamiento (swipe)
      drawer: const CustomNexusDrawer(), 
      body: Stack(
        children: [
          // Fondo decorativo (opcional, para dar profundidad)
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: accentTeal.withOpacity(0.1),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // 2. Barra Superior con botón atrás y menú
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "NOTIFICACIONES",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      // Botón para abrir el drawer manualmente si no quieren deslizar
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.sort, color: Colors.greenAccent),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Campo de Búsqueda con estilo Glassmorphism
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Buscar en el historial...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: const BorderSide(color: accentTeal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. Lista de Notificaciones
                Expanded(
                  child: notifications.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationCard(notifications[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, 
               size: 80, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          Text(
            "Bandeja de entrada vacía",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D), // Un poco más claro que el fondo
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF017A74).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, color: Colors.greenAccent, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}