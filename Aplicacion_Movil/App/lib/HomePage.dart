import 'package:flutter/material.dart';
import 'package:gestor/perfil.dart';

import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/notificationView.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),

      // 🔹 APPBAR
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "INVENTARY MOBILE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        // 🔹 MENÚ PERFIL
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            onSelected: (value) {
              if (value == "perfil") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerfilPage(
                      nombre: "Jorge",
                      email: "jorge@email.com",
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "perfil",
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text("Mi perfil"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "config",
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("Configuración"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Cerrar sesión"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),

      // 🔹 DRAWER
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40),

            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.move_to_inbox, color: Colors.white, size: 38),
                    SizedBox(width: 12),
                    Text(
                      "Mobile Inventory",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  "Tu inventario siempre bajo control",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white30),
            const SizedBox(height: 15),

            menuButton(context, Icons.inventory, "Gestionar Productos"),
            menuButton(context, Icons.file_copy, "Gestionar Reportes",
                page: const GestionarReportes()),
            menuButton(context, Icons.warehouse, "Visualizar Stock",
                page: const VisualizarStock()),
            menuButton(context, Icons.person, "Gestionar Cliente",
                page: const Cliente()),
            menuButton(context, Icons.local_shipping, "Gestionar Proveedores",
                page: const Proveedores()),
            menuButton(context, Icons.warning, "Revisar Alertas",
                page: const NotificationView()),
            menuButton(context, Icons.monetization_on, "Controlar Finanzas",
                page: const Controlar_Gastos()),
            menuButton(context, Icons.storefront, "Gestionar Inventario",
                page: GestionarInventarioPage()),
            menuButton(context, Icons.settings, "Configuracion",
                page: const Configuracion()),
          ],
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 100),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardCard(context, "Gestionar Productos", Icons.inventory),
              dashboardCard(context, "Gestionar Reportes", Icons.file_copy,
                  page: const GestionarReportes()),
              dashboardCard(context, "Visualizar Stock",
                  Icons.inventory_rounded,
                  page: const VisualizarStock()),
            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardCard(context, "Gestionar Cliente", Icons.person,
                  page: const Cliente()),
              dashboardCard(context, "Gestionar Proveedores",
                  Icons.local_shipping,
                  page: const Proveedores()),
              dashboardCard(context, "Revisar Alertas", Icons.warning,
                  page: const NotificationView()),
            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardCard(context, "Controlar Finanzas",
                  Icons.monetization_on,
                  page: const Controlar_Gastos()),
              dashboardCard(context, "Gestionar Inventario",
                  Icons.storefront,
                  page: GestionarInventarioPage()),
              dashboardCard(context, "Configurar", Icons.settings,
                  page: const Configuracion()),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 BOTONES DRAWER
  static Widget menuButton(
    BuildContext context,
    IconData icon,
    String text, {
    Widget? page,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: ElevatedButton.icon(
        onPressed: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  // 🔹 TARJETAS DASHBOARD
  static Widget dashboardCard(
    BuildContext context,
    String text,
    IconData icon, {
    Widget? page,
  }) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}