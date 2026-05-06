import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
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

  // --- LÓGICA DE API ---
  Future<void> fetchClientes() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/clientes')));
      if (response.statusCode == 200) {
        setState(() {
          clientes = json.decode(response.body);
          cargando = false;
        });
      }
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  Future<void> _eliminarCliente(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.url('/cliente/$id')),
      );
      if (response.statusCode == 200) {
        fetchClientes();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
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
          "LISTA DE CLIENTES",
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

  // Card del cliente con soporte para Long Press
  Widget _buildClienteCard(Map<String, dynamic> cliente) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        onLongPress: () => _mostrarOpciones(cliente),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF017A74).withOpacity(0.2),
          child: Text(
            cliente['nombre'][0].toString().toUpperCase(),
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          cliente['nombre'].toString().toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          cliente['celular'] ?? 'SIN TELÉFONO',
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        trailing: const Icon(
          Icons.more_vert,
          color: Color(0xFF017A74),
          size: 18,
        ),
      ),
    );
  }

  // --- DIÁLOGOS CON TU ESTÉTICA (Captura 1) ---

  void _mostrarOpciones(Map<String, dynamic> cliente) {
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
                cliente['nombre'].toString().toUpperCase(),
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
              Icons.edit,
              "EDITAR CLIENTE",
              Colors.cyanAccent,
              () {
                Navigator.pop(context);
                _abrirEditor(cliente);
              },
            ),
            _buildOptionItem(
              Icons.delete_sweep,
              "ELIMINAR DE REGISTROS",
              Colors.redAccent,
              () {
                Navigator.pop(context);
                _eliminarCliente(cliente['id_cliente']);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // --- FORMULARIO DE EDICIÓN (Captura 2) ---

  void _abrirEditor(Map<String, dynamic> cliente) {
    final nomCtrl = TextEditingController(text: cliente['nombre']);
    final dirCtrl = TextEditingController(
      text: cliente['direccion_residencia'],
    );
    final corCtrl = TextEditingController(text: cliente['gmail_corporativo']);
    final telCtrl = TextEditingController(text: cliente['celular']);

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
                "EDITAR PRODUCTO", // Mantengo el título de tu captura por estética
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
              _inputMinimal("Celular", telCtrl),
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
                          ApiConfig.url('/cliente/${cliente['id_cliente']}'),
                        ),
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

  // --- COMPONENTES VISUALES ---

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
              Icons.analytics_outlined,
              color: Colors.cyanAccent,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              "TOTAL CLIENTES :",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${clientes.length}",
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
          MaterialPageRoute(builder: (context) => Nuevocliente()),
        ).then((_) => fetchClientes()),
      ),
    );
  }
}
