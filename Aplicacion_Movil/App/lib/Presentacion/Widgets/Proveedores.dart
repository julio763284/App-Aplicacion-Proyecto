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

  // --- LÓGICA DE API ---
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
        _notificar("Proveedor eliminado ✅", Colors.greenAccent);
        fetchProveedores();
      }
    } catch (e) {
      _notificar("Error al eliminar", Colors.redAccent);
    }
  }

  void _notificar(String msj, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msj,
          style: const TextStyle(
            color: Color(0xFF0D1B1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- DISEÑO DE LA INTERFAZ ---

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
          "PROVEEDORES NEXUS",
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
                : proveedores.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: fetchProveedores,
                    color: Colors.cyanAccent,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: proveedores.length,
                      itemBuilder: (context, index) =>
                          _buildProveedorCard(proveedores[index]),
                    ),
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
        onLongPress: () =>
            _mostrarOpciones(proveedor), // DETECTA PRESIÓN PROLONGADA
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

  // --- DIÁLOGOS DE GESTIÓN (ESTÉTICA SAPOO) ---

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
                  letterSpacing: 1,
                ),
              ),
            ),
            _buildOptionItem(
              Icons.edit_note,
              "EDITAR PROVEEDOR",
              Colors.cyanAccent,
              () {
                Navigator.pop(context);
                _abrirEditor(proveedor);
              },
            ),
            _buildOptionItem(
              Icons.delete_forever,
              "ELIMINAR PROVEEDOR",
              Colors.redAccent,
              () {
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

  // --- FORMULARIO DE EDICIÓN MINIMALISTA ---

  void _abrirEditor(Map<String, dynamic> proveedor) {
    final nomCtrl = TextEditingController(text: proveedor['nombre']);
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
              _inputMinimal("Nombre Empresa", nomCtrl),
              _inputMinimal("Correo Electrónico", corCtrl),
              _inputMinimal("Teléfono / Celular", telCtrl),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CANCELAR",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
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
                          "gmail": corCtrl.text,
                          "telefono": telCtrl.text,
                        }),
                      );
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        _notificar("Cambios guardados", Colors.cyanAccent);
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

  // --- WIDGETS AUXILIARES ---

  Widget _buildOptionItem(
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
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
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
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
          border: Border.all(color: const Color(0xFF017A74), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              color: Colors.cyanAccent,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              "TOTAL PROVEEDORES :",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${proveedores.length}",
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_transport_rounded,
            size: 80,
            color: Colors.white.withOpacity(0.05),
          ),
          const Text(
            "SIN PROVEEDORES",
            style: TextStyle(
              color: Colors.white24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
