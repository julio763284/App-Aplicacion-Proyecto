import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Diseño/appbar.dart';
import 'package:intl/intl.dart';

class GestionarReportes extends StatefulWidget {
  const GestionarReportes({super.key});
  @override
  State<GestionarReportes> createState() => _InformesViewState();
}

class _InformesViewState extends State<GestionarReportes> {
  List<dynamic> informes = [];

  @override
  void initState() {
    super.initState();
    cargarReportes();
  }

  Future<void> cargarReportes() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/reportes')));
      if (response.statusCode == 200) {
        setState(() {
          informes = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> eliminarInforme(String id) async {
    try {
      await http.delete(Uri.parse(ApiConfig.url('/reporte/$id')));
      cargarReportes();
    } catch (e) {
      debugPrint("Error al eliminar: $e");
    }
  }

  void mostrarOpciones(Map<String, dynamic> r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF162A2D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text("Editar", style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); showInformeDialog(informe: r); },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text("Eliminar", style: TextStyle(color: Colors.redAccent)),
              onTap: () { Navigator.pop(context); eliminarInforme(r['id_reporte'].toString()); },
            ),
          ],
        ),
      ),
    );
  }

  void showInformeDialog({Map<String, dynamic>? informe}) {
    final tCtrl = TextEditingController(text: informe?['titulo'] ?? "");
    final dCtrl = TextEditingController(text: informe?['descripcion'] ?? "");
    final mCtrl = TextEditingController(text: informe?['monto']?.toString() ?? "");

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF162A2D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(informe == null ? "Nuevo Reporte" : "Editar Informe", style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: tCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Título", labelStyle: TextStyle(color: Colors.white70))),
              TextField(controller: dCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Descripción", labelStyle: TextStyle(color: Colors.white70))),
              TextField(controller: mCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Monto", labelStyle: TextStyle(color: Colors.white70))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar", style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF017A74)),
              onPressed: () async {
                final url = informe == null ? ApiConfig.url('/reporte') : ApiConfig.url('/reporte/${informe['id_reporte']}');
                final body = json.encode({"titulo": tCtrl.text, "descripcion": dCtrl.text, "monto": mCtrl.text});
                if (informe == null) await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
                else await http.put(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);
                cargarReportes();
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(conteoNotificaciones: 0, onActualizarNotificaciones: () {}),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => showInformeDialog(),
        child: const Icon(Icons.add, size: 30),
      ),
      body: informes.isEmpty
          ? Center(child: Text("No hay reportes", style: TextStyle(color: Colors.white.withOpacity(0.4))))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: informes.length,
              itemBuilder: (context, index) {
                final r = informes[index];
                String fechaFormateada = "Fecha no disponible";
                if (r['fecha'] != null) {
                  try {
                    fechaFormateada = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(r['fecha'].toString()));
                  } catch (_) {}
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: const Color(0xFF162A2D), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
                  child: ListTile(
                    onLongPress: () => mostrarOpciones(r),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(r['titulo']?.toString() ?? "Sin título", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(r['descripcion']?.toString() ?? "", style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.greenAccent),
                            const SizedBox(width: 5),
                            Text(fechaFormateada, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}