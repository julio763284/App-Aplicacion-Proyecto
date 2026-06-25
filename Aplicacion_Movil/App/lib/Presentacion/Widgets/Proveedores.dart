import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
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
          cargando    = false;
        });
      }
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  Future<void> _eliminarProveedor(int id) async {
    try {
      final response = await http.delete(Uri.parse(ApiConfig.url('/proveedor/$id')));
      if (response.statusCode == 200) fetchProveedores();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;

    return Scaffold(
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        conteoNotificaciones: 0,
        onActualizarNotificaciones: () {},
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator(color: cyan))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: proveedores.length,
                    itemBuilder: (context, index) {
                      if (index >= proveedores.length) return const SizedBox.shrink();
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
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: ListTile(
        onLongPress: () => _mostrarOpciones(proveedor),
        leading: CircleAvatar(
          backgroundColor: teal.withOpacity(0.2),
          child: Text(
            proveedor['nombre'] != null && proveedor['nombre'].toString().isNotEmpty
                ? proveedor['nombre'][0].toString().toUpperCase()
                : '?',
            style: TextStyle(color: cyan, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          proveedor['nombre'].toString().toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          proveedor['gmail'] ?? 'SIN CORREO',
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
        trailing: Icon(Icons.local_shipping_outlined, color: teal, size: 18),
      ),
    );
  }

  void _mostrarOpciones(Map<String, dynamic> proveedor) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: teal),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: cyan),
              title: Text("EDITAR PROVEEDOR",
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12)),
              onTap: () {
                Navigator.pop(context);
                _abrirEditor(proveedor);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              title: Text("ELIMINAR PROVEEDOR",
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 12)),
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
    final theme  = Theme.of(context);
    final cyan   = theme.colorScheme.secondary;
    final teal   = theme.colorScheme.primary;
    final nomCtrl = TextEditingController(text: proveedor['nombre']);
    final dirCtrl = TextEditingController(text: proveedor['direccion']);
    final corCtrl = TextEditingController(text: proveedor['gmail']);
    final telCtrl = TextEditingController(text: proveedor['telefono']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: teal),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("EDITAR PROVEEDOR",
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              _inputMinimal("Nombre",    nomCtrl),
              _inputMinimal("Dirección", dirCtrl),
              _inputMinimal("Correo",    corCtrl),
              _inputMinimal("Teléfono",  telCtrl),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCELAR",
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                  TextButton(
                    onPressed: () async {
                      final response = await http.put(
                        Uri.parse(ApiConfig.url('/proveedor/${proveedor['id_proveedor']}')),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({
                          "nombre":    nomCtrl.text,
                          "direccion": dirCtrl.text,
                          "gmail":     corCtrl.text,
                          "telefono":  telCtrl.text,
                        }),
                      );
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        fetchProveedores();
                      }
                    },
                    child: Text("GUARDAR",
                        style: TextStyle(color: cyan, fontWeight: FontWeight.bold)),
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
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return TextField(
      controller: ctrl,
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: cyan, fontSize: 12),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cyan),
        ),
      ),
    );
  }

  Widget _buildFooterCounter() {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.all(20),
      color: theme.scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      child: Text(
        "TOTAL PROVEEDORES : ${proveedores.length}",
        style: TextStyle(
          color: cyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFab() {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return FloatingActionButton(
      backgroundColor: theme.scaffoldBackgroundColor,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nuevoproveedor()),
      ).then((_) => fetchProveedores()),
      child: Icon(Icons.add, color: cyan),
    );
  }
}