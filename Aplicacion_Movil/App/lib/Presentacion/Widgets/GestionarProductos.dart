import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o_Home/Botones_drawer.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/nuevoproducto.dart';

class Gestionarproductos extends StatelessWidget {
  const Gestionarproductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 122, 116),
        title: Text("Productos", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white,),
          onPressed: (){print("buscar");}),
          IconButton(icon: Icon(Icons.sort_by_alpha, color: Colors.white),
          onPressed: (){print("Filtrar por Letra");}),
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: (){print("Ver Opciones");})
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
              page: Gestionarproductos(),
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
      
      body: Scaffold(
        floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 1, 122, 116),
        onPressed: () {
          Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Nuevoproducto(),
      ),
      );
          // lógica aquí
        },
        child: const Icon(Icons.add),
      ),
      ) ,
    );
}
}