import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Diseño/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Controlar_Gastos extends StatefulWidget {
  const Controlar_Gastos({super.key});

  @override
  State<Controlar_Gastos> createState() => _Controlar_GastosState();
}

class _Controlar_GastosState extends State<Controlar_Gastos> {
  List<dynamic> _reportes = [];
  bool _isLoading = true;

  static const primaryDark = Color(0xFF0D1B1E);
  static const accentTeal = Color(0xFF017A74);
  static const neonGreen = Color(0xFF00FFC2);

  @override
  void initState() {
    super.initState();
    _fetchReportes();
  }

  Future<void> _fetchReportes() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/reportes')));
      if (response.statusCode == 200) {
        setState(() {
          _reportes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  double get _balanceTotal {
    return _reportes.fold(0.0, (sum, r) {
      final monto = double.tryParse(r['monto'].toString()) ?? 0.0;
      return sum + monto;
    });
  }

  void _abrirFormulario({Map<String, dynamic>? reporte}) {
    final tituloCtrl = TextEditingController(text: reporte?['titulo'] ?? '');
    final descCtrl =
        TextEditingController(text: reporte?['descripcion'] ?? '');
    final montoCtrl = TextEditingController(
      text: reporte != null ? reporte['monto'].toString() : '',
    );
    final esEdicion = reporte != null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: accentTeal, width: 1),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esEdicion ? "EDITAR FINANZA" : "NUEVA FINANZA",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              _inputField("Título", tituloCtrl, Icons.title),
              const SizedBox(height: 14),
              _inputField("Descripción", descCtrl, Icons.notes),
              const SizedBox(height: 14),
              _inputField(
                "Monto",
                montoCtrl,
                Icons.attach_money,
                type: TextInputType.number,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CANCELAR",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      final titulo = tituloCtrl.text.trim();
                      final desc = descCtrl.text.trim();
                      final monto =
                          double.tryParse(montoCtrl.text.trim()) ?? 0.0;

                      if (titulo.isEmpty || desc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Completa todos los campos"),
                          ),
                        );
                        return;
                      }

                      http.Response response;
                      if (esEdicion) {
                        response = await http.put(
                          Uri.parse(
                            ApiConfig.url(
                              '/reporte/${reporte!['id_reporte']}',
                            ),
                          ),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "titulo": titulo,
                            "descripcion": desc,
                            "monto": monto,
                          }),
                        );
                      } else {
                        response = await http.post(
                          Uri.parse(ApiConfig.url('/reporte')),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "titulo": titulo,
                            "descripcion": desc,
                            "monto": monto,
                          }),
                        );
                      }

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Navigator.pop(context);
                        _fetchReportes();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              esEdicion
                                  ? "Finanza actualizada ✅"
                                  : "Finanza registrada ✅",
                            ),
                            backgroundColor: Colors.greenAccent,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error al guardar ❌"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "GUARDAR",
                      style: TextStyle(
                        color: neonGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _eliminarReporte(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.redAccent),
        ),
        title: const Text(
          "¿Eliminar finanza?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Esta acción no se puede deshacer.",
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "CANCELAR",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "ELIMINAR",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await http.delete(
        Uri.parse(ApiConfig.url('/reporte/$id')),
      );
      if (response.statusCode == 200) {
        _fetchReportes();
      }
    }
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        prefixIcon: Icon(icon, color: neonGreen, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentTeal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: neonGreen),
            )
          : RefreshIndicator(
              onRefresh: _fetchReportes,
              color: neonGreen,
              backgroundColor: const Color(0xFF162A2D),
              child: Column(
                children: [
                  Expanded(
                    child: _reportes.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 80),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: neonGreen.withOpacity(0.05),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: neonGreen.withOpacity(0.1),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 80,
                                    color: neonGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Center(
                                child: Text(
                                  "SIN REGISTROS",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "Presiona el botón + para añadir una finanza",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            itemCount: _reportes.length,
                            itemBuilder: (context, index) {
                              final r = _reportes[index];
                              final monto =
                                  double.tryParse(r['monto'].toString()) ?? 0.0;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF162A2D),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                ),
                                child: ListTile(
                                  onLongPress: () => _mostrarOpciones(r),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: neonGreen.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.receipt_long_outlined,
                                      color: neonGreen,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    r['titulo'].toString().toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    r['descripcion'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$ ${monto.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: neonGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Icon(
                                        Icons.more_vert,
                                        color: accentTeal,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  // Balance total
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "BALANCE TOTAL",
                          style: TextStyle(
                            color: Colors.white38,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "\$ ${_balanceTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: neonGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neonGreen,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add, color: primaryDark),
      ),
    );
  }

  void _mostrarOpciones(Map<String, dynamic> reporte) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: accentTeal),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.cyanAccent),
              title: const Text(
                "EDITAR FINANZA",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _abrirFormulario(reporte: reporte);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              title: const Text(
                "ELIMINAR FINANZA",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _eliminarReporte(reporte['id_reporte']);
              },
            ),
          ],
        ),
      ),
    );
  }
}