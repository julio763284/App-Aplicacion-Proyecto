import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarProductos.dart';

// ⚠️ IMPORTANTE: Revisa que estas rutas sean las mismas de tu proyecto
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';

class CustomNexusDrawer extends StatelessWidget {
  const CustomNexusDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.75, 
      child: Stack(
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B1E).withOpacity(0.85),
                  border: const Border(
                    right: BorderSide(color: Colors.white10, width: 0.5),
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(), 
                const Divider(color: Colors.white10, thickness: 1, indent: 20, endIndent: 20),
                
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      _buildSectionTitle("OPERACIONES"),
                      _drawerItem(context, Icons.inventory_2_outlined, "Productos", const Gestionarproductos()),
                      _drawerItem(context, Icons.storefront_outlined, "Inventario", const GestionInventarioView()),
                      _drawerItem(context, Icons.people_alt_outlined, "Clientes", const Cliente()),
                      _drawerItem(context, Icons.local_shipping_outlined, "Proveedores", const Proveedores()),
                      
                      const SizedBox(height: 15),
                      
                      _buildSectionTitle("ANÁLISIS"),
                      _drawerItem(context, Icons.analytics_outlined, "Reportes", const GestionarReportes()),
                      _drawerItem(context, Icons.warehouse_outlined, "Stock", const VisualizarStock()),
                      _drawerItem(context, Icons.notifications_active_outlined, "Alertas", const NotificationView()),
                      _drawerItem(context, Icons.payments_outlined, "Finanzas", const Controlar_Gastos()),
                      
                      const SizedBox(height: 15),
                      
                      _buildSectionTitle("SISTEMA"),
                      _drawerItem(context, Icons.settings_outlined, "Configuración", const Configuracion()),
                      const Divider(color: Colors.white10),
                      _drawerItem(context, Icons.logout_rounded, "Cerrar Sesión", const Gestionarproductos()), // Cambiar por tu logout
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Título de la sección (Operaciones, Análisis, etc)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 15, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.cyanAccent.withOpacity(0.5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  // Elemento individual del menú
  Widget _drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context); // Cierra el menú antes de navegar
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  // Logo y Nombre arriba
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          const Icon(Icons.blur_on, color: Colors.cyanAccent, size: 35),
          const SizedBox(width: 15),
          const Text(
            "NEXUS GESTOR",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}