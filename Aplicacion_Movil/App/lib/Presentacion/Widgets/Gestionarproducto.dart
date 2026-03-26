import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o_Home/Botones_drawer.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/Widgets/NuevoCliente.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';


class Gestionarproducto extends StatelessWidget {
  const Gestionarproducto({super.key});

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
              page: GestionarInventarioPage(),
            ),
            MenuButton(
              icon: Icons.settings,
              text: "Configuración",
              page: const Configuracion(),
            ),
          ],
        ),
      ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color:Color.fromARGB(255, 1, 122, 116).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Color.fromARGB(255, 1, 122, 116) ,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Agregar Cliente",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Seleccionar + para agregar Clientes",
              style: TextStyle(fontSize: 14, color: Colors.grey),
                
            ),
          ],  
        ),
      ),
       floatingActionButton: FloatingActionButton(
  backgroundColor: Color.fromARGB(255, 1, 122, 116),
  child: const Icon(Icons.add, color: Colors.white),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person_add, color: Color.fromARGB(255, 1, 122, 116)),
                title: Text("Nuevo Cliente"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>Nuevocliente(),
      ),
      );
                },
              ),
              ListTile(
                leading: Icon(Icons.upload_file, color: Color.fromARGB(255, 1, 122, 116)),
                title: Text("Importar Clientes"),
                onTap: () {
                  Navigator.pop(context);
                  print("Importar clientes");
                },
              ),
              ListTile(
                leading: Icon(Icons.close, color: Colors.red),
                title: Text("Cancelar"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  },
),
    );
  }
}