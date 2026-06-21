import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/core/config.dart';
import 'package:http/http.dart' as http;
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarReportes();
  }

  Future<void> cargarReportes() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/reportes')));
      if (response.statusCode == 200) {
        setState(() {
          informes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  String _formatearMonto(dynamic monto) {
    final valor = double.tryParse(monto.toString()) ?? 0.0;
    final formatter = NumberFormat('#,##0', 'es_CO');
    return '\$ ${formatter.format(valor).replaceAll(',', '.')}';
  }

  Color _colorEstado(String estado) {
    switch (estado.toUpperCase()) {
      case 'PAGADO':
        return Colors.greenAccent;
      case 'PENDIENTE':
        return Colors.orangeAccent;
      case 'EMPACANDO':
      case 'EN_TRANSITO':
        return Colors.cyanAccent;
      case 'ENTREGADO':
        return Colors.blueAccent;
      default:
        return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(conteoNotificaciones: 0, onActualizarNotificaciones: () {}),
      body: RefreshIndicator(
        onRefresh: cargarReportes,
        color: Colors.greenAccent,
        backgroundColor: const Color(0xFF162A2D),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
            : informes.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: 200),
                      Center(
                        child: Text(
                          "No hay pedidos registrados",
                          style: TextStyle(color: Colors.white.withOpacity(0.4)),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: informes.length,
                    itemBuilder: (context, index) {
                      final r = informes[index];
                      String fechaFormateada = "Fecha no disponible";
                      if (r['fecha'] != null) {
                        try {
                          fechaFormateada = DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(r['fecha'].toString()));
                        } catch (_) {}
                      }

                      // Extrae el estado del texto de la descripción (formato: "Cliente: X | Estado: Y | Z")
                      String estado = '';
                      final desc = r['descripcion']?.toString() ?? '';
                      final match = RegExp(r'Estado: (\w+)').firstMatch(desc);
                      if (match != null) estado = match.group(1) ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162A2D),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r['titulo']?.toString() ?? "Sin título",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              if (estado.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _colorEstado(estado).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: _colorEstado(estado).withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    estado,
                                    style: TextStyle(color: _colorEstado(estado), fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: Colors.greenAccent),
                                  const SizedBox(width: 5),
                                  Text(fechaFormateada, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                                  const Spacer(),
                                  Text(
                                    _formatearMonto(r['monto']),
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
} 