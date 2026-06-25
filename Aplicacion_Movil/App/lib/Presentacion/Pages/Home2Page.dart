import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarProductos.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';

class Homepagebody extends StatelessWidget {
  const Homepagebody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        int columns = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 3 : 2);
        double childAspectRatio = isMobile ? 1.1 : 1.3;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isMobile ? 20 : 80),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                    children: [
                      _nexusCard(context, "Supports",     Icons.file_copy,           const GestionarChats(),    isMobile),
                      _nexusCard(context, "Stock",        Icons.warehouse,            const VisualizarStock(),   isMobile),
                      _nexusCard(context, "Clientes",     Icons.person,               const Cliente(),           isMobile),
                      _nexusCard(context, "Proveedores",  Icons.local_shipping,       const Proveedores(),       isMobile),
                      _nexusCard(context, "Alertas",      Icons.warning,              const NotificationView(),  isMobile, isAlert: true),
                      _nexusCard(context, "Finanzas",     Icons.monetization_on,      const Controlar_Gastos(),  isMobile),
                      _nexusCard(context, "Productos",    Icons.inventory_2_outlined, const Gestionarproductos(),isMobile),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: isMobile ? 100 : 140,
                    child: Row(
                      children: [
                        Expanded(child: _nexusCard(context, "Inventario",    Icons.storefront, GestionInventarioView(), isMobile)),
                        const SizedBox(width: 12),
                        Expanded(child: _nexusCard(context, "Configuración", Icons.settings,   const Configuracion(),   isMobile)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                      const SizedBox(width: 10),
                      Text(
                        "SERVIDOR CONECTADO",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.greenAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _nexusCard(
    BuildContext context,
    String titulo,
    IconData icono,
    Widget page,
    bool isMobile, {
    bool isAlert = false,
  }) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 15 : 25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isMobile ? 15 : 25),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.3),
                    width: 1,
                  ),
                  color: theme.cardColor.withOpacity(0.05),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(isMobile ? 15 : 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isMobile ? 12 : 18),
              color: isAlert
                  ? Colors.red.withOpacity(0.1)
                  : teal.withOpacity(0.08),
              border: Border.all(
                color: isAlert
                    ? Colors.redAccent.withOpacity(0.5)
                    : cyan.withOpacity(0.2),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icono,
                  color: isAlert ? Colors.redAccent : cyan,
                  size: isMobile ? 22 : 28,
                ),
                const SizedBox(height: 6),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 9 : 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}