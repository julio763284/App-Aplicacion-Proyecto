import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Pages/Home2Page.dart';
import 'package:gestor/Presentacion/Widgets/Gestionarproducto.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/perfil.dart';
import 'package:gestor/Presentacion/Diseño_Home/Botones_drawer.dart'; 

class Homepage2 extends StatelessWidget {
  const Homepage2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 122, 116),
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

      // 🔹 DRAWER o Menu Desplegable //
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 1, 122, 116),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                const SizedBox(height: 6),
                const Text(
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

            // 🔹 BOTONES DEL DRAWER
            MenuButton(
              icon: Icons.inventory,
              text: "Gestionar Productos",
              page: Gestionarproducto(),
            ),
            MenuButton(
              icon: Icons.file_copy,
              text: "Gestionar Reportes",
              page: const GestionarReportes(),
            ),
            MenuButton(
              icon: Icons.warehouse,
              text: "Visualizar Stock",
              page: const VisualizarStock(),
            ),
            MenuButton(
              icon: Icons.person,
              text: "Gestionar Cliente",
              page: const Cliente(),
            ),
            MenuButton(
              icon: Icons.local_shipping,
              text: "Gestionar Proveedores",
              page: const Proveedores(),
            ),
            MenuButton(
              icon: Icons.warning,
              text: "Revisar Alertas",
              page: const NotificationView(),
            ),
            MenuButton(
              icon: Icons.monetization_on,
              text: "Controlar Finanzas",
              page: const Controlar_Gastos(),
            ),
            MenuButton(
              icon: Icons.storefront,
              text: "Gestionar Inventario",
              page: GestionInventarioView(),
            ),
            MenuButton(
              icon: Icons.settings,
              text: "Configuración",
              page: const Configuracion(),
            ),
          ],
        ),
      ),

      // 🔹 Cuerpo de la vista //
      body: Homepagebody(),
    );
  }
}

