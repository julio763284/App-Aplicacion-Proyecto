import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestor/Presentacion/Widgets/CustomAppBar.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  bool _notificacionesActivas = true;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencia();
  }

  Future<void> _cargarPreferencia() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificacionesActivas = prefs.getBool('notificaciones_activas') ?? true;
      _cargando = false;
    });
  }

  Future<void> _guardarPreferencia(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificaciones_activas', valor);
    setState(() => _notificacionesActivas = valor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teal  = theme.colorScheme.primary;
    final cyan  = theme.colorScheme.secondary;

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: const CustomAppBar(
        titulo: "GENERAL",
        conteoNotificaciones: 0,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator(color: cyan))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                  ),
                  child: SwitchListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    activeColor: teal,
                    activeTrackColor: teal.withOpacity(0.4),
                    title: Text(
                      "Notificaciones push",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      _notificacionesActivas
                          ? "Recibirás alertas de stock bajo y novedades"
                          : "No recibirás notificaciones",
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    value: _notificacionesActivas,
                    onChanged: _guardarPreferencia,
                  ),
                ),
              ],
            ),
    );
  }
}