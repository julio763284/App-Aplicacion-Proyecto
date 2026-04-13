import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Widgets/GestionarReportes.dart';
import 'package:gestor/Presentacion/Widgets/Visualizar_Stock.dart';
import 'package:gestor/Presentacion/Widgets/Cliente.dart';
import 'package:gestor/Presentacion/Widgets/Proveedores.dart';
import 'package:gestor/Presentacion/Widgets/NotificationView.dart';
import 'package:gestor/Presentacion/Widgets/Controlar_Gastos.dart';
import 'package:gestor/Presentacion/Widgets/gestionar_inventario.dart';
import 'package:gestor/Presentacion/Widgets/Configuracion.dart';

class HomepageBodyLayout extends StatelessWidget {
  const HomepageBodyLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1B1E), Color(0xFF002B28)], 
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 35),
              Expanded(
                flex: 4,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    // Quitamos const de las páginas para evitar errores de compilación
                    nexusFrostedGlassCard(context, "Reportes", Icons.file_copy, GestionarReportes()),
                    nexusFrostedGlassCard(context, "Stock", Icons.warehouse, VisualizarStock()),
                    nexusFrostedGlassCard(context, "Clientes", Icons.person, Cliente()),
                    nexusFrostedGlassCard(context, "Proveedores", Icons.local_shipping, Proveedores()),
                    nexusFrostedGlassCard(context, "Alertas", Icons.warning, NotificationView(), isAlert: true),
                    nexusFrostedGlassCard(context, "Finanzas", Icons.monetization_on, Controlar_Gastos()),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 140,
                child: Row(
                  children: [
                    Expanded(child: nexusFrostedGlassCard(context, "Inventario", Icons.storefront, GestionInventarioView())),
                    const SizedBox(width: 12),
                    Expanded(child: nexusFrostedGlassCard(context, "Configuración", Icons.settings, Configuracion())),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Indicador de Servidor
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                  SizedBox(width: 10),
                  Text(
                    "SERVIDOR CONECTADO", 
                    style: TextStyle(
                      color: Colors.greenAccent, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 1.5
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget nexusFrostedGlassCard(BuildContext context, String titulo, IconData icono, Widget page, {bool isAlert = false}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isAlert ? Colors.red.withOpacity(0.1) : const Color(0xFF017A74).withOpacity(0.08),
              border: Border.all(
                color: isAlert ? Colors.redAccent.withOpacity(0.5) : Colors.cyanAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, color: isAlert ? Colors.redAccent : Colors.cyanAccent, size: 26),
                const SizedBox(height: 8),
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}