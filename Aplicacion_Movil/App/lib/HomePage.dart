import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6), // fondo gris claro

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
      ),

      // DRAWER
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            const SizedBox(height: 40),

            Column(
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.move_to_inbox,
                        color: Colors.white, size: 38),
                    SizedBox(width: 12),
                    Text(
                      "Mobile Inventory",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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

            const Divider(
              color: Colors.white30,
              thickness: 1,
            ),

            const SizedBox(height: 15),

            menuButton(Icons.inventory, "Gestionar Productos"),
            menuButton(Icons.file_copy, "Gestionar Reportes"),
            menuButton(Icons.warehouse, "Visualizar Stock"),
            menuButton(Icons.person, "Gestionar Cliente"),
            menuButton(Icons.local_shipping, "Gestionar Proveedores"),
            menuButton(Icons.warning, "Revisar Alertas"),
            menuButton(Icons.monetization_on, "Controlar Finanzas"),
            menuButton(Icons.storefront, "Gestionar Inventario"),
            menuButton(Icons.settings, "Configuracion"),
          ],
        ),
      ),

      // DASHBOARD
      body: ListView(
        children: [

          const SizedBox(height: 100),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              dashboardCard("Gestionar Productos", Icons.inventory),

              dashboardCard("Gestionar Reportes", Icons.file_copy),

              dashboardCard("Visualizar Stock", Icons.inventory_rounded),

            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              dashboardCard("Gestionar Cliente", Icons.person),

              dashboardCard("Gestionar Proveedores", Icons.local_shipping),

              dashboardCard("Revisar Alertas", Icons.warning),

            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              dashboardCard("Controlar Finanzas", Icons.monetization_on),

              dashboardCard("Gestionar Inventario", Icons.storefront),

              dashboardCard("Configurar", Icons.settings),

            ],
          ),
        ],
      ),
    );
  }

  // BOTONES DEL DRAWER
  static Widget menuButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  // TARJETAS DEL DASHBOARD (como tu diseño original pero mejoradas)
  static Widget dashboardCard(String text, IconData icon) {
    return Container(
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

          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),

        ],
      ),
    );
  }
}