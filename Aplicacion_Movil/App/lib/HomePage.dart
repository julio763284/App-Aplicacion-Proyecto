import 'package:flutter/material.dart';
import 'package:gestor/perfil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),

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
            const Divider(color: Colors.white30, thickness: 1),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.inventory, color: Colors.white),
                label: const Text("Gestionar Productos",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_copy, color: Colors.white),
                label: const Text("Gestionar Reportes",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.warehouse, color: Colors.white),
                label: const Text("Visualizar Stock",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person, color: Colors.white),
                label: const Text("Gestionar Cliente",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.local_shipping, color: Colors.white),
                label: const Text("Gestionar Proveedor",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.warning, color: Colors.white),
                label: const Text("Revisar Alertas",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.monetization_on, color: Colors.white),
                label: const Text("Controlar Finanzas",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.storefront, color: Colors.white),
                label: const Text("Gestionar Inventario",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text("Configuracion",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  alignment: Alignment.centerLeft,
                ),
              ),
            )
          ],
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 100),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardContainer("Gestionar Productos", Icons.inventory),
              dashboardContainer("Gestionar Reportes", Icons.file_copy),
              dashboardContainer(
                  "Visualizar Stock", Icons.inventory_rounded),
            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardContainer("Gestionar Cliente", Icons.person),
              dashboardContainer(
                  "Gestionar Proveedores", Icons.local_shipping),
              dashboardContainer("Revisar Alertas", Icons.warning),
            ],
          ),

          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              dashboardContainer(
                  "Controlar Finanzas", Icons.monetization_on),
              dashboardContainer(
                  "Gestionar Inventario", Icons.storefront),
              dashboardContainer("Configurar", Icons.settings),
            ],
          ),
        ],
      ),
    );
  }

  Widget dashboardContainer(String text, IconData icon) {
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
          Icon(icon, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}