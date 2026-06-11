import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:gestor/Presentacion/Widgets/CustomAppBar.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Configuracion extends StatelessWidget {
  const Configuracion({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: const CustomAppBar(
        titulo: "AJUSTES",
        conteoNotificaciones: 0,
        mostrarNotificaciones: true,
        mostrarPerfil: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                const Text(
                  "Preferencias del Sistema",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const ItemAjusteNexus(icono: Icons.settings_outlined, texto: "General"),
                const ItemAjusteNexus(icono: Icons.visibility_outlined, texto: "Vista y Tema"),
                const ItemAjusteNexus(icono: Icons.business_outlined, texto: "Datos de Mi Empresa"),
                const ItemAjusteNexus(icono: Icons.qr_code_scanner_outlined, texto: "Escáner de Barras"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ItemAjusteNexus(
              icono: Icons.logout_rounded,
              texto: "Cerrar Sesión",
              esAlerta: true,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ItemAjusteNexus extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool esAlerta;
  final VoidCallback? onTap;

  const ItemAjusteNexus({
    super.key,
    required this.icono,
    required this.texto,
    this.esAlerta = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: esAlerta ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: onTap,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: esAlerta ? Colors.redAccent.withOpacity(0.1) : const Color(0xFF017A74).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, color: esAlerta ? Colors.redAccent : Colors.greenAccent, size: 22),
              ),
              title: Text(
                texto,
                style: TextStyle(
                  color: esAlerta ? Colors.redAccent : Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
            ),
          ),
        ),
      ),
    );
  }
}