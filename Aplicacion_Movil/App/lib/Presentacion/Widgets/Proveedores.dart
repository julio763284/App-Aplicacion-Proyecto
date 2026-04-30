import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestor/Presentacion/core/config.dart';
import 'package:gestor/Presentacion/Widgets/NuevoProveedor.dart'; 
import 'package:gestor/Presentacion/Widgets/custom_drawer.dart';
import 'package:gestor/Presentacion/Widgets/custom_app_bar.dart'; 

class Proveedores extends StatefulWidget {
  const Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  // Variables para la lógica de búsqueda
  List<dynamic> _allProveedores = [];
  List<dynamic> _filteredProveedores = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
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
        final data = json.decode(response.body);
        setState(() {
          _allProveedores = data;
          _filteredProveedores = data;
          cargando = false;
        });
      }
    } catch (e) {
      setState(() => cargando = false);
      debugPrint("Error en Nexus Proveedores: $e");
    }
  }

  // Función para filtrar la lista
  void _filterProveedores(String query) {
    setState(() {
      _filteredProveedores = _allProveedores
          .where((p) => p['nombre']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF0D1B1E);
    const greenAccent = Colors.greenAccent;

    return Scaffold(
      backgroundColor: primaryDark,
      drawer: const CustomNexusDrawer(),
      appBar: CustomAppBar(
        title: "PROVEEDORES",
        titleWidget: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: "BUSCAR PROVEEDOR...",
                hintStyle: TextStyle(color: greenAccent.withOpacity(0.3)),
                border: InputBorder.none,
              ),
              onChanged: _filterProveedores,
            )
          : null,
        onSearchPressed: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchController.clear();
              _filteredProveedores = _allProveedores;
            }
          });
        },
      ),
      body: cargando 
        ? const Center(child: CircularProgressIndicator(color: greenAccent))
        : _filteredProveedores.isEmpty 
          ? _buildEmptyState()
          : RefreshIndicator(
              color: greenAccent,
              onRefresh: fetchProveedores, 
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _filteredProveedores.length,
                itemBuilder: (context, index) => _buildProveedorCard(_filteredProveedores[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenAccent,
        child: const Icon(Icons.add, size: 30, color: primaryDark),
        onPressed: () => _mostrarMenuOpciones(context), 
      ),
    );
  }

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
          const Text("SIN RESULTADOS", 
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(_isSearching ? "No se encontraron coincidencias" : "Toca el botón + para registrar uno", 
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
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
                leading: const Icon(Icons.add_business_rounded, color: Colors.greenAccent),
                title: const Text("Nuevo Proveedor", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); 
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