import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarProductos.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarSoportes.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';

class CustomNexusDrawer extends StatelessWidget {
  const CustomNexusDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Stack(
        children: [
          // Fondo con blur
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.92),
                  border: Border(
                    right: BorderSide(
                        color: theme.dividerColor.withOpacity(0.2), width: 0.5),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Divider(
                    color: theme.dividerColor.withOpacity(0.3),
                    thickness: 1,
                    indent: 20,
                    endIndent: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      _buildSectionTitle("OPERACIONES", context),
                      _drawerItem(context, Icons.inventory_2_outlined,   "Productos",     const Gestionarproductos()),
                      _drawerItem(context, Icons.storefront_outlined,    "Inventario",    const GestionInventarioView()),
                      _drawerItem(context, Icons.people_alt_outlined,    "Clientes",      const Cliente()),
                      _drawerItem(context, Icons.local_shipping_outlined,"Proveedores",   const Proveedores()),
                      const SizedBox(height: 15),
                      _buildSectionTitle("ANÁLISIS", context),
                      _drawerItem(context, Icons.analytics_outlined,              "Soportes", const GestionarChats()),
                      _drawerItem(context, Icons.warehouse_outlined,               "Stock",    const VisualizarStock()),
                      _drawerItem(context, Icons.notifications_active_outlined,    "Alertas",  const NotificationView()),
                      const SizedBox(height: 15),
                      _buildSectionTitle("SISTEMA", context),
                      _drawerItem(context, Icons.settings_outlined, "Configuración", const Configuracion()),
                      Divider(color: theme.dividerColor.withOpacity(0.2)),
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

  Widget _buildSectionTitle(String title, BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 15, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: cyan.withOpacity(0.6),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String title, Widget page) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7), size: 22),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Icon(Icons.blur_on, color: cyan, size: 35),
          const SizedBox(width: 15),
          Text(
            "NEXUS GESTOR",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}