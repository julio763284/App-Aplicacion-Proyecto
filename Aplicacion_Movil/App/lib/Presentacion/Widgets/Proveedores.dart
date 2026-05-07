import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/NuevoProveedor.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({super.key});
  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  List<dynamic> proveedores = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchProveedores();
  }

  Future<void> fetchProveedores() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/proveedores')));
      if (response.statusCode == 200) {
        setState(() {
          proveedores = json.decode(response.body);
          cargando = false;
        });
      }
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  Future<void> _eliminarProveedor(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.url('/proveedor/$id')),
      );
      if (response.statusCode == 200) fetchProveedores();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B1E),
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
        elevation: 0,
        title: const Text(
          "PROVEEDORES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: proveedores.length,
                    itemBuilder: (context, index) {
                      // Validación de seguridad para evitar RangeError
                      if (index >= proveedores.length)
                        return const SizedBox.shrink();
                      return _buildProveedorCard(proveedores[index]);
                    },
                  ),
                ),
                _buildFooterCounter(),
              ],
            ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildProveedorCard(Map<String, dynamic> proveedor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onLongPress: () => _mostrarOpciones(proveedor),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
          child: Text(
            proveedor['nombre'] != null &&
                    proveedor['nombre'].toString().isNotEmpty
                ? proveedor['nombre'][0].toString().toUpperCase()
                : '?',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          proveedor['nombre'].toString().toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          proveedor['gmail'] ?? 'SIN CORREO',
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        trailing: const Icon(
          Icons.local_shipping_outlined,
          color: Color(0xFF017A74),
          size: 18,
        ),
      ),
    );
  }

  void _mostrarOpciones(Map<String, dynamic> proveedor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFF017A74)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.cyanAccent),
              title: const Text(
                "EDITAR PROVEEDOR",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _abrirEditor(proveedor);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              title: const Text(
                "ELIMINAR PROVEEDOR",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _eliminarProveedor(proveedor['id_proveedor']);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _abrirEditor(Map<String, dynamic> proveedor) {
    final nomCtrl = TextEditingController(text: proveedor['nombre']);
    final dirCtrl = TextEditingController(text: proveedor['direccion']);
    final corCtrl = TextEditingController(text: proveedor['gmail']);
    final telCtrl = TextEditingController(text: proveedor['telefono']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF017A74)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "EDITAR PROVEEDOR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _inputMinimal("Nombre", nomCtrl),
              _inputMinimal("Dirección", dirCtrl),
              _inputMinimal("Correo", corCtrl),
              _inputMinimal("Teléfono", telCtrl),
              const SizedBox(height: 20),
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
                  TextButton(
                    onPressed: () async {
                      final response = await http.put(
                        Uri.parse(
                          ApiConfig.url(
                            '/proveedor/${proveedor['id_proveedor']}',
                          ),
                        ),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "nombre": nomCtrl.text,
                          "direccion": dirCtrl.text,
                          "gmail": corCtrl.text,
                          "telefono": telCtrl.text,
                        }),
                      );
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        fetchProveedores();
                      }
                    },
                    child: const Text(
                      "GUARDAR",
                      style: TextStyle(color: Colors.cyanAccent),
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

  Widget _inputMinimal(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
      ),
    );
  }

  Widget _buildFooterCounter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF0D1B1E),
      alignment: Alignment.centerLeft,
      child: Text(
        "TOTAL PROVEEDORES : ${proveedores.length}",
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF0D1B1E),
      child: const Icon(Icons.add, color: Colors.cyanAccent),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nuevoproveedor()),
      ).then((_) => fetchProveedores()),
    );
  }
}
