import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestor/Presentacion/Widgets/CustomAppBar.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/core/theme_provider.dart';

class VistaTemaPage extends StatelessWidget {
  const VistaTemaPage({super.key});

  static const Color accentTeal = Color(0xFF017A74);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: const CustomAppBar(
        titulo: "VISTA Y TEMA",
        conteoNotificaciones: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Apariencia",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _opcionTema(
            context,
            titulo: "Modo Oscuro",
            subtitulo: "Fondo oscuro, ideal para uso nocturno",
            icono: Icons.dark_mode_outlined,
            seleccionado: themeProvider.modoOscuro,
            onTap: () => themeProvider.cambiarModo(true),
          ),
          const SizedBox(height: 12),
          _opcionTema(
            context,
            titulo: "Modo Claro",
            subtitulo: "Fondo claro, ideal para uso diurno",
            icono: Icons.light_mode_outlined,
            seleccionado: !themeProvider.modoOscuro,
            onTap: () => themeProvider.cambiarModo(false),
          ),
        ],
      ),
    );
  }

  Widget _opcionTema(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: seleccionado ? accentTeal : theme.dividerColor,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, color: accentTeal, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (seleccionado)
              const Icon(Icons.check_circle, color: accentTeal, size: 22),
          ],
        ),
      ),
    );
  }
}