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
      if (response.statusCode == 200) {
        fetchProveedores();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const accentTeal = Color(0xFF017A74);

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: AppBar(
        backgroundColor: accentTeal.withOpacity(0.2),
        elevation: 0,
        title: const Text(
          "PROVEEDORES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.cyanAccent),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: proveedores.length,
                    itemBuilder: (context, index) =>
                        _buildProveedorCard(proveedores[index]),
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
            proveedor['nombre'][0].toString().toUpperCase(),
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
          side: const BorderSide(color: Color(0xFF017A74), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF017A74), width: 0.8),
                ),
              ),
              child: Text(
                proveedor['nombre'].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.cyanAccent,
                size: 20,
              ),
              title: const Text(
                "EDITAR PROVEEDOR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _abrirEditor(proveedor);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_sweep,
                color: Colors.redAccent,
                size: 20,
              ),
              title: const Text(
                "ELIMINAR PROVEEDOR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _eliminarProveedor(proveedor['id_proveedor']);
              },
            ),
            const SizedBox(height: 8),
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
          side: const BorderSide(color: Color(0xFF017A74), width: 1),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "EDITAR PROVEEDOR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _inputMinimal("Nombre", nomCtrl),
              _inputMinimal("Dirección", dirCtrl),
              _inputMinimal("Correo", corCtrl),
              _inputMinimal("Teléfono", telCtrl),
              const SizedBox(height: 30),
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
                  const SizedBox(width: 20),
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
                      style: TextStyle(
                        color: Colors.cyanAccent,
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

  Widget _inputMinimal(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
          ),
          TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterCounter() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF017A74)),
        ),
        child: Text(
          "TOTAL PROVEEDORES : ${proveedores.length}",
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF0D1B1E),
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.cyanAccent),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Nuevoproveedor()),
        ).then((_) => fetchProveedores()),
      ),
    );
  }
}
