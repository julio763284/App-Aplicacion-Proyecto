import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestor/Presentacion/Dise%C3%B1o/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/NuevoCliente.dart';
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Cliente extends StatefulWidget {
  const Cliente({super.key});

  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  List<dynamic> clientes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/clientes')));
      if (response.statusCode == 200) {
        setState(() {
          clientes = json.decode(response.body);
          cargando = false;
        });
      } else {
        setState(() => cargando = false);
      }
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  Future<void> _eliminarCliente(int id) async {
    try {
      final response = await http.delete(Uri.parse(ApiConfig.url('/cliente/$id')));
      if (response.statusCode == 200) fetchClientes();
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
      body: Column(
        children: [
          Expanded(
            child: cargando
                ? Center(child: CircularProgressIndicator(color: cyan))
                : clientes.isEmpty
                    ? Center(
                        child: Text(
                          "NO HAY CLIENTES REGISTRADOS",
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: clientes.length,
                        itemBuilder: (context, index) =>
                            _buildClienteCard(clientes[index]),
                      ),
          ),
          _buildFooterCounter(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildClienteCard(Map<String, dynamic> cliente) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    final String nombre = (cliente['nombre_completo'] ?? cliente['nombre'] ?? 'SIN NOMBRE').toString();
    final String telefono = (cliente['telefono'] ?? cliente['celular'] ?? 'SIN TELÉFONO').toString();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
      ),
      child: ListTile(
        onLongPress: () => _mostrarOpciones(cliente),
        leading: CircleAvatar(
          backgroundColor: teal.withOpacity(0.2),
          child: Text(
            nombre.isNotEmpty ? nombre[0].toUpperCase() : 'C',
            style: TextStyle(color: cyan, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          nombre.toUpperCase(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          telefono,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
        trailing: InkWell(
          onTap: () => _mostrarOpciones(cliente),
          child: Icon(Icons.more_vert, color: teal, size: 18),
        ),
      ),
    );
  }

  void _mostrarOpciones(Map<String, dynamic> cliente) {
    final theme = Theme.of(context);
    final teal  = theme.colorScheme.primary;
    final cyan  = theme.colorScheme.secondary;
    final String nombre = (cliente['nombre_completo'] ?? cliente['nombre'] ?? 'CLIENTE').toString();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: teal, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: teal, width: 0.8)),
              ),
              child: Text(
                nombre.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            ),
            _buildOptionItem(Icons.edit, "EDITAR CLIENTE", cyan, () {
              Navigator.pop(context);
              _abrirEditor(cliente);
            }),
            _buildOptionItem(Icons.delete_sweep, "ELIMINAR DE REGISTROS", Colors.redAccent, () {
              Navigator.pop(context);
              _eliminarCliente(cliente['id_cliente']);
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _abrirEditor(Map<String, dynamic> cliente) {
    final theme  = Theme.of(context);
    final cyan   = theme.colorScheme.secondary;
    final nomCtrl = TextEditingController(text: cliente['nombre_completo'] ?? cliente['nombre']);
    final dirCtrl = TextEditingController(text: cliente['direccion_residencia']);
    final corCtrl = TextEditingController(text: cliente['gmail_corporativo'] ?? cliente['correo_electronico']);
    final telCtrl = TextEditingController(text: cliente['telefono'] ?? cliente['celular']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.primary, width: 1),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("EDITAR CLIENTE",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                _inputMinimal("Nombre",    nomCtrl),
                _inputMinimal("Dirección", dirCtrl),
                _inputMinimal("Correo",    corCtrl),
                _inputMinimal("Celular",   telCtrl),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CANCELAR",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () async {
                        final response = await http.put(
                          Uri.parse(ApiConfig.url('/cliente/${cliente['id_cliente']}')),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "nombre": nomCtrl.text,
                            "direccion_residencia": dirCtrl.text,
                            "gmail_corporativo": corCtrl.text,
                            "celular": telCtrl.text,
                          }),
                        );
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          fetchClientes();
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
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String text, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 20),
      title: Text(text,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _inputMinimal(String label, TextEditingController ctrl) {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                color: cyan,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              )),
          TextField(
            controller: ctrl,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: cyan),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterCounter() {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    final teal  = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: teal, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_outlined, color: cyan, size: 16),
            const SizedBox(width: 8),
            Text("TOTAL CLIENTES :",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(width: 8),
            Text("${clientes.length}",
                style: TextStyle(
                  color: cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    final theme = Theme.of(context);
    final cyan  = theme.colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cyan.withOpacity(0.5), width: 1.5),
      ),
      child: FloatingActionButton(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Nuevocliente()),
        ).then((_) => fetchClientes()),
        child: Icon(Icons.add, color: cyan),
      ),
    );
  }
}