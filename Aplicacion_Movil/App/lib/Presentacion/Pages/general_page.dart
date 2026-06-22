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
  static const Color primaryDark = Color(0xFF0D1B1E);
  static const Color accentTeal = Color(0xFF017A74);

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
    setState(() {
      _notificacionesActivas = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: const CustomAppBar(
        titulo: "GENERAL",
        conteoNotificaciones: 0,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    activeColor: accentTeal,
                    activeTrackColor: accentTeal.withOpacity(0.4),
                    title: const Text(
                      "Notificaciones push",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      _notificacionesActivas
                          ? "Recibirás alertas de stock bajo y novedades"
                          : "No recibirás notificaciones",
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
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