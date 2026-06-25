import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Pages/LoginHome.dart';
import 'package:gestor/Presentacion/Widgets/CustomAppBar.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Pages/general_page.dart';
import 'package:gestor/Presentacion/Pages/vista_tema_page.dart';

class Configuracion extends StatelessWidget {
  const Configuracion({super.key});

  Future<void> _confirmarCerrarSesion(BuildContext context) async {
    final theme = Theme.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              "Cerrar sesión",
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "¿Estás seguro de que deseas cerrar sesión?",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar", style: theme.textTheme.bodyMedium),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí, salir"),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  "Preferencias del Sistema",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 30),
                ItemAjusteNexus(
                  icono: Icons.settings_outlined,
                  texto: "General",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GeneralPage()),
                  ),
                ),
                ItemAjusteNexus(
                  icono: Icons.visibility_outlined,
                  texto: "Vista y Tema",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VistaTemaPage()),
                  ),
                ),
                const ItemAjusteNexus(
                  icono: Icons.business_outlined,
                  texto: "Datos de Mi Empresa",
                ),
                const ItemAjusteNexus(
                  icono: Icons.qr_code_scanner_outlined,
                  texto: "Escáner de Barras",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ItemAjusteNexus(
              icono: Icons.logout_rounded,
              texto: "Cerrar Sesión",
              esAlerta: true,
              onTap: () => _confirmarCerrarSesion(context),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: esAlerta ? Colors.redAccent.withOpacity(0.2) : theme.dividerColor,
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
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: esAlerta ? Colors.redAccent : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, color: theme.dividerColor, size: 14),
            ),
          ),
        ),
      ),
    );
  }
}
