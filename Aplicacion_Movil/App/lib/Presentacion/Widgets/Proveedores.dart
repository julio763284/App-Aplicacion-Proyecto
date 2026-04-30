import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/NuevoProveedor.dart'; // Asegúrate de que el nombre coincida
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  // COMENTARIO: Lista dinámica para almacenar lo que viene de MySQL
  List<dynamic> proveedores = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchProveedores(); // Carga inicial
  }

  // COMENTARIO: Función para obtener datos. 
  // Recuerda que en Python debe ser "ORDER BY id DESC" para que el nuevo salga arriba.
  Future<void> fetchProveedores() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.url('/registro_proveedor')));
      if (response.statusCode == 200) {
        setState(() {
          proveedores = json.decode(response.body);
          cargando = false;
        });
      }
    } catch (e) {
      setState(() => cargando = false);
      debugPrint("Error en Nexus Proveedores: $e");
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
        title: const Text("PROVEEDORES", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.sort, color: Colors.greenAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      // COMENTARIO: Lógica de estados (Cargando -> Vacío -> Lista)
      body: cargando 
        ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
        : proveedores.isEmpty 
          ? _buildEmptyState()
          : RefreshIndicator(
              color: Colors.greenAccent,
              onRefresh: fetchProveedores, // COMENTARIO: Permite actualizar deslizando hacia abajo
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: proveedores.length,
                itemBuilder: (context, index) => _buildProveedorCard(proveedores[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, size: 30, color: primaryDark),
        onPressed: () => _mostrarMenuOpciones(context), // Abre el menú con estilo
      ),
    );
  }

  // COMENTARIO: Diseño de la tarjeta del proveedor (idéntico al de clientes)
  Widget _buildProveedorCard(Map<String, dynamic> proveedor) {
    final String nombre = proveedor['nombre'] ?? 'Sin nombre';
    final String gmail = proveedor['gmail'] ?? 'Sin correo';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF162A2D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          radius: 25,
          child: Text(
            nombre[0].toUpperCase(), 
            style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)
          ),
        ),
        title: Text(nombre, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(gmail, 
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
        trailing: const Icon(Icons.local_shipping_outlined, color: Colors.greenAccent, size: 20),
      ),
    );
  }

  // COMENTARIO: Estado vacío con el icono de camión de Nexus
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 170, height: 170,
            decoration: const BoxDecoration(color: Color(0xFF162A2D), shape: BoxShape.circle),
            child: const Icon(Icons.local_shipping_rounded, size: 80, color: Colors.greenAccent),
          ),
          const SizedBox(height: 30),
          const Text("SIN PROVEEDORES", 
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Toca el botón + para registrar uno", 
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
        ],
      ),
    );
  }

  // COMENTARIO: Menú inferior con desenfoque de fondo
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
                leading: const Icon(Icons.add_business_rounded, color: Colors.greenAccent),
                title: const Text("Nuevo Proveedor", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú
                  // COMENTARIO: Al volver de registrar, refresca la lista automáticamente
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Nuevoproveedor())
                  ).then((_) => fetchProveedores()); 
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}