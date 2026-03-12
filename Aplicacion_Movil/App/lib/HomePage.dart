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

        //  MENU PERFIL
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

            menuButton(context, Icons.inventory, "Gestionar Productos"),
            menuButton(context, Icons.file_copy, "Gestionar Reportes"),
            menuButton(context, Icons.warehouse, "Visualizar Stock"),
            menuButton(context, Icons.person, "Gestionar Cliente"),
            menuButton(context, Icons.local_shipping, "Gestionar Proveedores"),
            menuButton(context, Icons.warning, "Revisar Alertas"),
            menuButton(context, Icons.monetization_on, "Controlar Finanzas"),
            menuButton(context, Icons.storefront, "Gestionar Inventario"),
            menuButton(context, Icons.settings, "Configuracion"),
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

  // 🔹 TARJETAS DASHBOARD
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
          Icon(icon, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}