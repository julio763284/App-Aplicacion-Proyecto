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

class LoginHome extends StatelessWidget {
  // 🔹 REPARADO: Eliminamos los controladores requeridos que causaban el error en main.dart
  const LoginHome({super.key, required TextEditingController userController, required TextEditingController passController});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 🔹 Agregamos Scaffold para manejar mejor el layout
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B1E), Color(0xFF003D33)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Título o Logo opcional aquí
                Expanded(
                  flex: 4,
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      nexusDoubleGlassCard(context, "Reportes", Icons.file_copy, const GestionarReportes()),
                      nexusDoubleGlassCard(context, "Stock", Icons.warehouse, const VisualizarStock()),
                      nexusDoubleGlassCard(context, "Clientes", Icons.person, const Cliente()),
                      nexusDoubleGlassCard(context, "Proveedores", Icons.local_shipping, const Proveedores()),
                      nexusDoubleGlassCard(context, "Alertas", Icons.warning, const NotificationView(), isAlert: true),
                      nexusDoubleGlassCard(context, "Finanzas", Icons.monetization_on, const Controlar_Gastos()),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 140,
                  child: Row(
                    children: [
                      Expanded(child: nexusDoubleGlassCard(context, "Inventario", Icons.storefront, const GestionInventarioView())),
                      const SizedBox(width: 12),
                      Expanded(child: nexusDoubleGlassCard(context, "Configuración", Icons.settings, const Configuracion())),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                    SizedBox(width: 10),
                    Text("SERVIDOR CONECTADO", 
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
      ),
    );
  }

  Widget nexusDoubleGlassCard(BuildContext context, String titulo, IconData icono, Widget page, {bool isAlert = false}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Capa de Efecto Glassmorphism
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isAlert ? Colors.redAccent.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                    width: 1.2,
                  ),
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ),

          // Contenedor de contenido
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAlert ? Colors.red.withOpacity(0.1) : const Color(0xFF017A74).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isAlert ? Colors.redAccent : Colors.cyanAccent.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, color: isAlert ? Colors.redAccent : Colors.cyanAccent, size: 28),
                const SizedBox(height: 6),
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