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
        title: const Text("CLIENTES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: cargando 
        ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
        : clientes.isEmpty 
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: fetchClientes,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: clientes.length,
                itemBuilder: (context, index) => _buildClienteCard(clientes[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, size: 30, color: primaryDark),
        onPressed: () => _mostrarMenuOpciones(context),
      ),
    );
  }

  Widget _buildClienteCard(Map<String, dynamic> cliente) {
    final String imagen = cliente['imagen'] ?? '';
    final String nombre = cliente['nombre'] ?? 'Sin nombre';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          radius: 25,
          backgroundImage: imagen.isNotEmpty ? NetworkImage(imagen) : null,
          child: imagen.isEmpty 
            ? Text(nombre[0].toUpperCase(), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))
            : null,
        ),
        title: Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text("Registrado: ${cliente['fecha_registro']}", 
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.greenAccent),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170, height: 170,
            decoration: const BoxDecoration(color: Color(0xFF162A2D), shape: BoxShape.circle),
            child: const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.greenAccent),
          ),
          const SizedBox(height: 30),
          const Text("SIN CLIENTES", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _mostrarMenuOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF162A2D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add_rounded, color: Colors.greenAccent),
                title: const Text("Nuevo Cliente", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Nuevocliente())).then((_) => fetchClientes());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}