import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/notificationView.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';

class Homepage2 extends StatelessWidget {
  const Homepage2({super.key});

  static const Color primaryColor = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("INVENTARY MOBILE"),
        backgroundColor: primaryColor,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          dashboardCard(
            context,
            "Gestionar Reportes",
            Icons.file_copy,
            const GestionarReportes(),
          ),

          dashboardCard(
            context,
            "Visualizar Stock",
            Icons.warehouse,
            const VisualizarStock(),
          ),

          dashboardCard(context, "Clientes", Icons.person, const Cliente()),

          dashboardCard(
            context,
            "Proveedores",
            Icons.local_shipping,
            const Proveedores(),
          ),

          dashboardCard(
            context,
            "Alertas",
            Icons.warning,
            const NotificationView(),
          ),

          dashboardCard(
            context,
            "Finanzas",
            Icons.monetization_on,
            const Controlar_Gastos(),
          ),

          // ✅ CORREGIDO AQUI
          dashboardCard(
            context,
            "Inventario",
            Icons.storefront,
            const GestionInventarioView(),
          ),

          dashboardCard(
            context,
            "Configuración",
            Icons.settings,
            const Configuracion(),
          ),
        ],
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String titulo,
    IconData icono,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.white, size: 32),
            const SizedBox(height: 10),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
